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
		'groupedAllocationSites',
		'startTime',
		'endTime',
		'taThreshold',
		'hif',
		'hlf',
		'pretenurator'
	],
	#category : 'IllimaniProfiler-Analyzer',
	#package : 'IllimaniProfiler',
	#tag : 'Analyzer'
}

{ #category : 'instance creation' }
IllAnalyzer class >> onProfiler: aProfiler [

	^ self new
		  setForProfiler: aProfiler;
		  yourself
]

{ #category : 'calculating' }
IllAnalyzer >> binObjects [

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

{ #category : 'as yet unclassified' }
IllAnalyzer >> cleanKernelAllocationSites: aCollection [ 

	^ aCollection reject: [ :e |
    | allocatedObjectClass  |
    allocatedObjectClass := (e allObjects collect: #allocatedObjectClass as: Set) anyOne.

    allocatedObjectClass = Context 
        or: [ allocatedObjectClass = Point 
        or: [ allocatedObjectClass = Deprecation 
        or: [ allocatedObjectClass = Process ] ] ] ].
]

{ #category : 'api' }
IllAnalyzer >> doMagic [

	| toPretenureSites allocationSendersList |
	self classifyAllocationSites.
	toPretenureSites := self pruneAllocationSites select: #isLongOrImmortal.
	toPretenureSites := self cleanKernelAllocationSites: toPretenureSites.
	toPretenureSites := self removeDoItAllocationSite: toPretenureSites.

	allocationSendersList := toPretenureSites values collect: [ :allocSiteBin |
		                         allocSiteBin allObjects first allocationSenders asMethodWithOffsetObjects ].
	pretenurator doMagic: allocationSendersList.
	^ pretenurator
]

{ #category : 'accessing' }
IllAnalyzer >> endTime: anInteger [ 
	endTime := anInteger
]

{ #category : 'calculating' }
IllAnalyzer >> groupAllocationSites [
	
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
IllAnalyzer >> initialize [

	super initialize.
	immortalObjectsBin := OrderedCollection new: 100000.
	shortObjectsBin := OrderedCollection new: 100000.
	longObjectsBin := OrderedCollection new: 10000.

	taThreshold := 0.45.
	hif := 0.
	hlf := 0.6.

	pretenurator := IllPretenurator new
]

{ #category : 'calculating' }
IllAnalyzer >> isObjectImmortal: illEphe [

	| timeOfDeath halfwayBirthtimeToEnd birthTime |
	timeOfDeath := illEphe finalizationTime min: endTime.
	birthTime := illEphe initializationTime.
	halfwayBirthtimeToEnd := birthTime + (endTime - illEphe initializationTime / 2).
	^ timeOfDeath > halfwayBirthtimeToEnd

	"^ totalTime - illEphe finalizationTime < illEphe lifetime"
]

{ #category : 'calculating' }
IllAnalyzer >> isObjectShortLived: illEphe [

	| age |
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

{ #category : 'api' }
IllAnalyzer >> pruneAllocationSites [

	| v totalProgramAllocations |
	v := 0.000002.
	totalProgramAllocations := objectAllocations size.
	^ groupedAllocationSites reject: [ :allocationSiteBin |
		  allocationSiteBin totalAllocations < (v * totalProgramAllocations) ]
]

{ #category : 'api' }
IllAnalyzer >> removeDoItAllocationSite: toPretenureSites [

	^ toPretenureSites reject: #hasDoItAllocationSite
]

{ #category : 'api' }
IllAnalyzer >> setForProfiler: profiler [

	self
		objectAllocations: profiler objectAllocations;
		endTime: profiler endTime;
		startTime: profiler startTime
]

{ #category : 'accessing' }
IllAnalyzer >> shortObjectsBin [

	^ shortObjectsBin
]

{ #category : 'accessing' }
IllAnalyzer >> startTime [
	^ startTime
]

{ #category : 'accessing' }
IllAnalyzer >> startTime: anInteger [ 
	startTime := anInteger
]

{ #category : 'accessing' }
IllAnalyzer >> totalTime [

	^ endTime - startTime
]
