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
		'taThreshold',
		'totalTime',
		'groupedAllocationSites'
	],
	#category : 'IllimaniProfiler-Analyzer',
	#package : 'IllimaniProfiler',
	#tag : 'Analyzer'
}

{ #category : 'calculating' }
IllAnalyzer >> binObjects [

	self groupAllocationSites.

	taThreshold := 0.45.
	initialAllocationTime := objectAllocations first initializationTime.

	objectAllocations do: [ :illEphe |
		| age isObjectClassified |
		isObjectClassified := false.
		age := illEphe lifetime / self maxLiveSize.

		(self isObjectImmortal: illEphe) ifTrue: [
			immortalObjectsBin add: illEphe.
			(groupedAllocationSites at: illEphe allocationSite)
				addImmortalObject: illEphe.
			isObjectClassified := true ].
		(isObjectClassified not and: [ self isObjectShortLived: illEphe age: age ]) ifTrue: [
			shortObjectsBin add: illEphe.
			(groupedAllocationSites at: illEphe allocationSite)
				addShortLivedObject: illEphe.
			isObjectClassified := true ].
		isObjectClassified ifFalse: [
			longObjectsBin add: illEphe.
			(groupedAllocationSites at: illEphe allocationSite)
				addShortLivedObject: illEphe. ] ]
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

	| timeOfDeath birthToEndOfProgram |
	"timeOfDeath := illEphe finalizationTime - initialAllocationTime."
	timeOfDeath := self timeOfDeathOf: illEphe.
	birthToEndOfProgram := totalTime - illEphe initializationTime.

	^ timeOfDeath > (birthToEndOfProgram / 2)

	"^ totalTime - illEphe finalizationTime < illEphe lifetime"
]

{ #category : 'calculating' }
IllAnalyzer >> isObjectShortLived: illEphe age: age [

	^ age < (taThreshold * self maxLiveSize)
]

{ #category : 'accessing' }
IllAnalyzer >> maxLiveSize [

	^ maxLiveSize ifNil: [ self calculateMaxLiveSize ]
]

{ #category : 'accessing' }
IllAnalyzer >> objectAllocations: col [

	objectAllocations := col
]

{ #category : 'calculating' }
IllAnalyzer >> timeOfDeathOf: illEphe [

	^ illEphe finalizationTime - initialAllocationTime / totalTime min: 1
]

{ #category : 'accessing' }
IllAnalyzer >> totalTime: anInteger [ 
	totalTime := anInteger
]
