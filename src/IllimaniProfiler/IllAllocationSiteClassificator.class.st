"
Allocation sites classification algorithm. Paper: https://www.steveblackburn.org/pubs/papers/pbp-toplas-2007.pdf
"
Class {
	#name : 'IllAllocationSiteClassificator',
	#superclass : 'Object',
	#instVars : [
		'longObjectsBin',
		'shortObjectsBin',
		'immortalObjectsBin',
		'objectAllocations',
		'maxLiveSize',
		'groupedAllocationSites',
		'startTime',
		'endTime',
		'taThreshold',
		'hif',
		'hlf'
	],
	#category : 'IllimaniProfiler-Analyzer',
	#package : 'IllimaniProfiler',
	#tag : 'Analyzer'
}

{ #category : 'calculating' }
IllAllocationSiteClassificator >> binObjects [

	self groupAllocationSites.

	objectAllocations do: [ :illEphe |
		| isObjectClassified |
		isObjectClassified := false.

		(self isObjectImmortal: illEphe) ifTrue: [
			immortalObjectsBin add: illEphe.
			(groupedAllocationSites at: illEphe allocationSite) addImmortalObject: illEphe.
			isObjectClassified := true ].
		(isObjectClassified not and: [ self isObjectShortLived: illEphe ]) ifTrue: [
			shortObjectsBin add: illEphe.
			(groupedAllocationSites at: illEphe allocationSite) addShortLivedObject: illEphe.
			isObjectClassified := true ].
		isObjectClassified ifFalse: [
			longObjectsBin add: illEphe.
			(groupedAllocationSites at: illEphe allocationSite) addLongLivedObject: illEphe ] ]
]

{ #category : 'calculating' }
IllAllocationSiteClassificator >> calculateMaxLiveSize [

	| aliveObjects currentTime initialTime aliveObjectsSize |
	maxLiveSize := 0.
	initialTime := objectAllocations first initializationTime.
	aliveObjects := OrderedCollection with: objectAllocations first.

	objectAllocations allButFirstDo: [ :illiEphemeron |
		| deadObjects |
		aliveObjectsSize := 0.
		
		currentTime := illiEphemeron initializationTime - initialTime.
		deadObjects := aliveObjects select: [ :e | currentTime >= (e finalizationTime - initialTime) ].
		aliveObjects removeAll: deadObjects.
		aliveObjects add: illiEphemeron.
		
		aliveObjects do: [ :e | aliveObjectsSize := aliveObjectsSize + e sizeInBytes ].
		maxLiveSize := maxLiveSize max: aliveObjectsSize ].

	^ maxLiveSize
]

{ #category : 'api' }
IllAllocationSiteClassificator >> classifyAllocationSites [

	self binObjects.

	groupedAllocationSites valuesDo: [ :allocationSiteBin |
		| is ss ls wasClassified |
		wasClassified := false.
		is := allocationSiteBin immortalObjects sum: #sizeInBytes.
		ss := allocationSiteBin shortLivedObjects sum: #sizeInBytes.
		ls := allocationSiteBin longLivedObjects sum: #sizeInBytes.

		is > (ss + ls + hif) ifTrue: [
			allocationSiteBin classification: #immortal.
			wasClassified := true ].
		(wasClassified not and: [ is + ls > (ss + hlf) ]) ifTrue: [
			allocationSiteBin classification: #long.
			wasClassified := true ].
		wasClassified ifFalse: [ allocationSiteBin classification: #short ] ]
]

{ #category : 'accessing' }
IllAllocationSiteClassificator >> endTime: anInteger [ 
	endTime := anInteger
]

{ #category : 'calculating' }
IllAllocationSiteClassificator >> groupAllocationSites [
	
	groupedAllocationSites := Dictionary new.
	objectAllocations do: [ :illEphe |
		| illAllocationSite|
		illAllocationSite := illEphe allocationSite.
		groupedAllocationSites
			at: illAllocationSite
			ifAbsentPut: (IllAllocationSiteBin new
				allocationSite: illAllocationSite;
				yourself) ]
]

{ #category : 'initialization' }
IllAllocationSiteClassificator >> initialize [

	super initialize.
	immortalObjectsBin := OrderedCollection new: 100000.
	shortObjectsBin := OrderedCollection new: 100000.
	longObjectsBin := OrderedCollection new: 10000.

	taThreshold := 0.45.
	hif := 0.
	hlf := 0.6
]

{ #category : 'calculating' }
IllAllocationSiteClassificator >> isObjectImmortal: illEphe [

	| timeOfDeath halfwayBirthtimeToEnd birthTime |
	timeOfDeath := illEphe finalizationTime min: endTime.
	birthTime := illEphe initializationTime.
	halfwayBirthtimeToEnd := birthTime + (endTime - illEphe initializationTime / 2).
	^ timeOfDeath > halfwayBirthtimeToEnd

	"^ totalTime - illEphe finalizationTime < illEphe lifetime"
]

{ #category : 'calculating' }
IllAllocationSiteClassificator >> isObjectShortLived: illEphe [

	| age |
	age := illEphe lifetime / self maxLiveSize.
	^ age < (taThreshold * self maxLiveSize)
]

{ #category : 'accessing' }
IllAllocationSiteClassificator >> maxLiveSize [

	^ maxLiveSize ifNil: [ self calculateMaxLiveSize ]
]

{ #category : 'accessing' }
IllAllocationSiteClassificator >> objectAllocations [
	^ objectAllocations
]

{ #category : 'accessing' }
IllAllocationSiteClassificator >> objectAllocations: aCollection [ 
	objectAllocations := aCollection
]

{ #category : 'api' }
IllAllocationSiteClassificator >> pruneAllocationSites [

	| v totalProgramAllocations |
	v := 0.000002.
	totalProgramAllocations := objectAllocations size.
	^ groupedAllocationSites reject: [ :allocationSiteBin |
		  allocationSiteBin totalAllocations < (v * totalProgramAllocations) ]
]

{ #category : 'api' }
IllAllocationSiteClassificator >> retrievePretenureSites [

	self classifyAllocationSites.
	^ self pruneAllocationSites select: #isLongOrImmortal
]

{ #category : 'accessing' }
IllAllocationSiteClassificator >> shortObjectsBin [

	^ shortObjectsBin
]

{ #category : 'accessing' }
IllAllocationSiteClassificator >> startTime [
	^ startTime
]

{ #category : 'accessing' }
IllAllocationSiteClassificator >> startTime: anInteger [ 
	startTime := anInteger
]

{ #category : 'accessing' }
IllAllocationSiteClassificator >> totalTime [

	^ endTime - startTime
]
