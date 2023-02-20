"
I am a model for calculating the statistics for the allocation profiler. My methods `allocationsByClass` and `allocationsByMethod` return the grouped and sorted allocations. Only access them by the accessors as they are lazy calculated 
"
Class {
	#name : #AllocationStatisticsWalker,
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
AllocationStatisticsWalker class >> allocations: someAllocations [

	^ self new
		allocations: someAllocations;
		yourself
]

{ #category : #statistics }
AllocationStatisticsWalker >> allocationsByClass [

	didIWalk ifFalse: [ self walkAllocations ].
	^ allocationNodesByClass sorted
]

{ #category : #statistics }
AllocationStatisticsWalker >> allocationsByMethod [

	didIWalk ifFalse: [ self walkAllocations ].
	^ allocationNodesByMethod sorted
]

{ #category : #initialization }
AllocationStatisticsWalker >> initialize [

	super initialize.
	allocationNodesByClass := AllocatorWithGroupedAllocationsCollection new.
	allocationNodesByMethod := AllocatorWithGroupedAllocationsCollection new.
	didIWalk := false
]

{ #category : #statistics }
AllocationStatisticsWalker >> numberOfClasses [

	^ self allocationsByClass size
]

{ #category : #statistics }
AllocationStatisticsWalker >> numberOfMethods [

	^ self allocationsByMethod size
]

{ #category : #accessing }
AllocationStatisticsWalker >> rawAllocations [

	^ rawAllocations
]

{ #category : #accessing }
AllocationStatisticsWalker >> rawAllocations: anObject [

	rawAllocations := anObject
]

{ #category : #'statistics - time' }
AllocationStatisticsWalker >> timeDifferenceBetweenFirstAndLastAllocation [

	^ rawAllocations last timestamp - rawAllocations first timestamp
]

{ #category : #statistics }
AllocationStatisticsWalker >> topNAllocationsByClass: n [

	| allocationsOrderedByClass |
	allocationsOrderedByClass := self allocationsByClass.
	^ allocationsOrderedByClass first: (n min: allocationsOrderedByClass size)
]

{ #category : #statistics }
AllocationStatisticsWalker >> topNAllocationsByMethod: n [

	| allocationsOrderedByMethod |
	allocationsOrderedByMethod := self allocationsByMethod.
	^ allocationsOrderedByMethod first: (n min: allocationsOrderedByMethod size)
]

{ #category : #statistics }
AllocationStatisticsWalker >> totalAllocatedObjects [

	^ rawAllocations size
]

{ #category : #statistics }
AllocationStatisticsWalker >> totalEqualAllocatedObjects [
	"This only makes sense if you kept the allocated objects in the profiler. If not, you will
	end up with a set with nil"

	^ (rawAllocations collect: [ :a | a allocatedObject ] as: Set) size
]

{ #category : #calculating }
AllocationStatisticsWalker >> walkAllocations [

	rawAllocations do: [ :allocationHolder |
		allocationNodesByClass
			updateAllocationForAllocator: allocationHolder allocatorClass
			allocation: allocationHolder.
		allocationNodesByMethod
			updateAllocationForAllocator: allocationHolder fullMethodName
			allocation: allocationHolder ].

	didIWalk := true
]
