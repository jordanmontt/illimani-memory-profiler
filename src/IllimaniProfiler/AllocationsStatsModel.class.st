"
I am a model for calculating the statistics for the allocation profiler. My methods `allocationsByClass` and `allocationsByMethod` return the grouped and sorted allocations. Only access them by the accessors as they are lazy calculated 
"
Class {
	#name : 'AllocationsStatsModel',
	#superclass : 'Object',
	#instVars : [
		'rawAllocations',
		'allocationNodesByMethod',
		'didIWalk'
	],
	#category : 'IllimaniProfiler-Model-Statistics',
	#package : 'IllimaniProfiler',
	#tag : 'Model-Statistics'
}

{ #category : 'accessing' }
AllocationsStatsModel class >> allocations: someAllocations [

	^ self new
		allocations: someAllocations;
		yourself
]

{ #category : 'statistics' }
AllocationsStatsModel >> allocationsByMethod [

	didIWalk ifFalse: [ self walkAllocations ].
	^ allocationNodesByMethod sortedByTotalAllocations
]

{ #category : 'initialization' }
AllocationsStatsModel >> initialize [

	super initialize.
	allocationNodesByMethod := GroupedAllocationsByAllocatorCollection new.
	didIWalk := false
]

{ #category : 'statistics' }
AllocationsStatsModel >> numberOfClasses [

	^ (self allocationsByMethod collect: [ :e | e allocator methodClass ] as: Set) size
]

{ #category : 'statistics' }
AllocationsStatsModel >> numberOfMethods [

	^ self allocationsByMethod size
]

{ #category : 'accessing' }
AllocationsStatsModel >> rawAllocations [

	^ rawAllocations
]

{ #category : 'accessing' }
AllocationsStatsModel >> rawAllocations: anObject [

	rawAllocations := anObject
]

{ #category : 'statistics - time' }
AllocationsStatsModel >> timeDifferenceBetweenFirstAndLastAllocation [

	^ rawAllocations last initializationTime - rawAllocations first initializationTime
]

{ #category : 'statistics' }
AllocationsStatsModel >> topNAllocationsByMethod: n [

	| allocationsOrderedByMethod |
	allocationsOrderedByMethod := self allocationsByMethod.
	^ allocationsOrderedByMethod first: (n min: allocationsOrderedByMethod size)
]

{ #category : 'statistics' }
AllocationsStatsModel >> totalAllocatedMemory [

	^ rawAllocations inject: 0 into: [ :sum : elem | sum + elem sizeInBytes ]
]

{ #category : 'statistics' }
AllocationsStatsModel >> totalAllocatedObjects [

	^ rawAllocations size
]

{ #category : 'calculating' }
AllocationsStatsModel >> walkAllocations [

	rawAllocations do: [ :allocationHolder |
		allocationNodesByMethod
			updateAllocationForAllocator: allocationHolder allocatorMethod
			allocation: allocationHolder ].

	didIWalk := true
]
