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
		'endOfProgram',
		'taThreshold',
		'totalAllocation'
	],
	#category : 'IllimaniProfiler-Analyzer',
	#package : 'IllimaniProfiler',
	#tag : 'Analyzer'
}

{ #category : 'as yet unclassified' }
IllAnalyzer >> analyzeAllocations: allocations [
	"The allocations are grouped and ordered by lifetime"

	allocations first: 10.
	1 halt
]

{ #category : 'accessing' }
IllAnalyzer >> calculateMaxLiveSize [

	| aliveObjects currentTime initialTime maxAlive |
	maxAlive := 0.
	initialTime := objectAllocations first initializationTime.
	aliveObjects := OrderedCollection with: objectAllocations first.

	objectAllocations allButFirstDo: [ :illiEphemeron |
		| deadObjects |
		currentTime := illiEphemeron initializationTime - initialTime.
		deadObjects := aliveObjects select: [ :e | currentTime > (e finalizationTime - initialTime) ].
		aliveObjects removeAll: deadObjects.
		aliveObjects add: illiEphemeron.
		aliveObjects size > maxAlive ifTrue: [ 
			maxAlive := aliveObjects size.
			maxLiveSize := aliveObjects sum: #sizeInBytes ] ].

	^ maxLiveSize
]

{ #category : 'api' }
IllAnalyzer >> classify [

	taThreshold := 0.2.
	initialAllocationTime := objectAllocations first initializationTime.
	endOfProgram := (objectAllocations max: #finalizationTime) - initialAllocationTime.

	objectAllocations do: [ :illEphe |
		| age timeOfDeath isObjectClassified |
		isObjectClassified := false.
		age := illEphe lifetime / self maxLiveSize.
		timeOfDeath := illEphe finalizationTime - initialAllocationTime / totalAllocation min: 1.

		(self isObjectImmortal: illEphe timeOfDeath: timeOfDeath) ifTrue: [
			immortalObjectsBin add: illEphe.
			isObjectClassified := true ].
		(self isObjectShortLived: illEphe age: age) ifTrue: [
			shortObjectsBin add: illEphe.
			isObjectClassified := true ].
		isObjectClassified ifFalse: [ longObjectsBin add: illEphe ] ]
]

{ #category : 'initialization' }
IllAnalyzer >> initialize [

	super initialize.
	immortalObjectsBin := OrderedCollection new.
	shortObjectsBin := OrderedCollection new.
	longObjectsBin := OrderedCollection new
]

{ #category : 'api' }
IllAnalyzer >> isObjectImmortal: illEphe timeOfDeath: timeOfDeath [

	^ timeOfDeath > (endOfProgram - (illEphe initializationTime - initialAllocationTime) / 2)
]

{ #category : 'api' }
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

{ #category : 'accessing' }
IllAnalyzer >> totalAllocation: totalAllocationInBytes [

	totalAllocation := totalAllocationInBytes
]
