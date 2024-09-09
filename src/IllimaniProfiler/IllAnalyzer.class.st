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
		'totalTime'
	],
	#category : 'IllimaniProfiler-Analyzer',
	#package : 'IllimaniProfiler',
	#tag : 'Analyzer'
}

{ #category : 'api' }
IllAnalyzer >> analyzeAllocations: allocations [
	"The allocations are grouped and ordered by lifetime"

	allocations first: 10.
	1 halt
]

{ #category : 'api' }
IllAnalyzer >> binObjects [

	taThreshold := 0.45.
	initialAllocationTime := objectAllocations first initializationTime.

	objectAllocations do: [ :illEphe |
		| age isObjectClassified |
		isObjectClassified := false.
		age := illEphe lifetime / self maxLiveSize.

		(self isObjectImmortal: illEphe) ifTrue: [
			immortalObjectsBin add: illEphe.
			isObjectClassified := true ].
		(isObjectClassified not and: [ self isObjectShortLived: illEphe age: age ]) ifTrue: [
			shortObjectsBin add: illEphe.
			isObjectClassified := true ].
		isObjectClassified ifFalse: [ longObjectsBin add: illEphe ] ]
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
IllAnalyzer >> classifyAllocationsSites [

	
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

{ #category : 'api' }
IllAnalyzer >> timeOfDeathOf: illEphe [

	^ illEphe finalizationTime - initialAllocationTime / totalTime min: 1
]

{ #category : 'accessing' }
IllAnalyzer >> totalTime: anInteger [ 
	totalTime := anInteger
]
