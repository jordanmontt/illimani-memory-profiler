"
I am a model for calculating the statistics for the allocation profiler. My methods `allocationsByClass` and `allocationsByMethod` return the grouped and sorted allocations. Only access them by the accessors as they are lazy calculated 
"
Class {
	#name : #AllocationStatistics,
	#superclass : #Object,
	#instVars : [
		'rawAllocations',
		'allocationNodesByClass',
		'allocationNodesByMethod',
		'didIWalk'
	],
	#category : #'AllocationProfiler-Statistics-Model'
}

{ #category : #accessing }
AllocationStatistics class >> allocations: someAllocations [

	^ self new
		allocations: someAllocations;
		yourself
]

{ #category : #statistics }
AllocationStatistics >> allocationsByClass [

	didIWalk ifFalse: [ self walkAllocations ].
	^ allocationNodesByClass sortedByTotalAllocations
]

{ #category : #statistics }
AllocationStatistics >> allocationsByMethod [

	didIWalk ifFalse: [ self walkAllocations ].
	^ allocationNodesByMethod sortedByTotalAllocations
]

{ #category : #initialization }
AllocationStatistics >> initialize [

	super initialize.
	allocationNodesByClass := AllocatorWithGroupedAllocationsCollection new.
	allocationNodesByMethod := AllocatorWithGroupedAllocationsCollection new.
	didIWalk := false
]

{ #category : #statistics }
AllocationStatistics >> numberOfClasses [

	^ self allocationsByClass size
]

{ #category : #statistics }
AllocationStatistics >> numberOfMethods [

	^ self allocationsByMethod size
]

{ #category : #accessing }
AllocationStatistics >> rawAllocations [

	^ rawAllocations
]

{ #category : #accessing }
AllocationStatistics >> rawAllocations: anObject [

	rawAllocations := anObject
]

{ #category : #'statistics - time' }
AllocationStatistics >> timeDifferenceBetweenFirstAndLastAllocation [

	^ rawAllocations last timestamp - rawAllocations first timestamp
]

{ #category : #statistics }
AllocationStatistics >> topNAllocationsByClass: n [

	| allocationsOrderedByClass |
	allocationsOrderedByClass := self allocationsByClass.
	^ allocationsOrderedByClass first: (n min: allocationsOrderedByClass size)
]

{ #category : #statistics }
AllocationStatistics >> topNAllocationsByMethod: n [

	| allocationsOrderedByMethod |
	allocationsOrderedByMethod := self allocationsByMethod.
	^ allocationsOrderedByMethod first: (n min: allocationsOrderedByMethod size)
]

{ #category : #statistics }
AllocationStatistics >> totalAllocatedMemory [

	^ rawAllocations inject: 0 into: [ :sum : elem | sum + elem totalSizeInBytes ]
]

{ #category : #statistics }
AllocationStatistics >> totalAllocatedObjects [

	^ rawAllocations size
]

{ #category : #statistics }
AllocationStatistics >> totalEqualAllocatedObjects [
	"This only makes sense if you kept the allocated objects in the profiler. If not, you will
	end up with a set with nil"

	^ (rawAllocations collect: [ :a | a allocatedObject ] as: Set) size
]

{ #category : #calculating }
AllocationStatistics >> walkAllocations [

	rawAllocations do: [ :allocationHolder |
		allocationNodesByClass
			updateAllocationForAllocator: allocationHolder allocatorClass
			allocation: allocationHolder.
		allocationNodesByMethod
			updateAllocationForAllocator: allocationHolder fullMethodName
			allocation: allocationHolder ].

	didIWalk := true
]
