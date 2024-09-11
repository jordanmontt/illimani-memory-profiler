"
Allocation sites classification algorithm. Paper: https://www.steveblackburn.org/pubs/papers/pbp-toplas-2007.pdf
"
Class {
	#name : 'IllAnalyzer',
	#superclass : 'Object',
	#instVars : [
		'longObjectsBin',
		'shortObjectsBin',
		'immortalObjectsBin',
		'objectAllocations',
		'maxLiveSize',
		'initialAllocationTime',
		'groupedAllocationSites',
		'startTime',
		'endTime'
	],
	#category : 'IllimaniProfiler-Analyzer',
	#package : 'IllimaniProfiler',
	#tag : 'Analyzer'
}

{ #category : 'calculating' }
IllAnalyzer >> binObjects [

	self groupAllocationSites.

	initialAllocationTime := objectAllocations first initializationTime.

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
IllAnalyzer >> calculateMaxLiveSize [

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
IllAnalyzer >> classifyAllocationSites [

	| hif hlf |
	
	self binObjects.
	
	hif := 0.
	hlf := 0.6.

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
IllAnalyzer >> endTime: anInteger [ 
	endTime := anInteger
]

{ #category : 'calculating' }
IllAnalyzer >> groupAllocationSites [
	
	groupedAllocationSites := Dictionary new.
	objectAllocations do: [ :illEphe |
		groupedAllocationSites
			at: illEphe allocationSite
			ifAbsentPut: IllAllocationSiteBin new ]
]

{ #category : 'initialization' }
IllAnalyzer >> initialize [

	super initialize.
	immortalObjectsBin := OrderedCollection new: 10000.
	shortObjectsBin := OrderedCollection new: 10000.
	longObjectsBin := OrderedCollection new: 10000
]

{ #category : 'calculating' }
IllAnalyzer >> isObjectImmortal: illEphe [

	| timeOfDeath halfwayBirthTimeToEnd |
	timeOfDeath := self timeOfDeathOf: illEphe.
	halfwayBirthTimeToEnd := (self totalTime - illEphe initializationTime) / 2.
	^ timeOfDeath > halfwayBirthTimeToEnd

	"^ totalTime - illEphe finalizationTime < illEphe lifetime"
]

{ #category : 'calculating' }
IllAnalyzer >> isObjectShortLived: illEphe [

	| age taThreshold |
	taThreshold := 0.45.
	age := illEphe lifetime / self maxLiveSize.
	^ age < (taThreshold * self maxLiveSize)
]

{ #category : 'accessing' }
IllAnalyzer >> maxLiveSize [

	^ maxLiveSize ifNil: [ self calculateMaxLiveSize ]
]

{ #category : 'accessing' }
IllAnalyzer >> objectAllocations [
	^ objectAllocations
]

{ #category : 'accessing' }
IllAnalyzer >> objectAllocations: col [

	objectAllocations := col
]

{ #category : 'accessing' }
IllAnalyzer >> startTime [
	^ startTime
]

{ #category : 'accessing' }
IllAnalyzer >> startTime: anInteger [ 
	startTime := anInteger
]

{ #category : 'calculating' }
IllAnalyzer >> timeOfDeathOf: illEphe [

	^ illEphe finalizationTime - initialAllocationTime min: self totalTime "/ totalTime min: 1"
]

{ #category : 'accessing' }
IllAnalyzer >> totalTime [

	^ endTime - startTime
]
