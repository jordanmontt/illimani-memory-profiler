Class {
	#name : 'IllAnalyzer',
	#superclass : 'Object',
	#instVars : [
		'oldObjectsBin',
		'shortObjectsBin',
		'immortalObjectsBin',
		'objectAllocations',
		'maxLiveSize'
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

	| aliveObjects currentTime initialTime |
	maxLiveSize := 0.
	initialTime := objectAllocations first initializationTime.
	aliveObjects := OrderedCollection with: objectAllocations first.

	objectAllocations allButFirstDo: [ :illiEphemeron |
		| deadObjects |
		currentTime := illiEphemeron initializationTime - initialTime.
		deadObjects := aliveObjects select: [ :e | currentTime > (e finalizationTime - initialTime) ].
		aliveObjects removeAll: deadObjects.
		aliveObjects add: illiEphemeron.
		maxLiveSize := maxLiveSize max: aliveObjects size ].

	^ maxLiveSize
]

{ #category : 'api' }
IllAnalyzer >> classify [

	| totalAllocatedObjects totalProfiledTime initialAllocationTime |
	initialAllocationTime := objectAllocations first initializationTime.
	totalAllocatedObjects := objectAllocations size.
	totalProfiledTime := (objectAllocations max: #finalizationTime)  - initialAllocationTime.

	objectAllocations do: [ :illEphe |
		| age timeOfDeath |
		age := illEphe lifetime / self maxLiveSize.
		timeOfDeath := (illEphe finalizationTime - initialAllocationTime / totalProfiledTime) min: 1.
		1 halt ]
]

{ #category : 'accessing' }
IllAnalyzer >> maxLiveSize [

	^ maxLiveSize ifNil: [ self calculateMaxLiveSize ]
]

{ #category : 'accessing' }
IllAnalyzer >> objectAllocations: col [

	objectAllocations := col
]
