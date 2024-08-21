Class {
	#name : 'FinalizationStatsModel',
	#superclass : 'Object',
	#instVars : [
		'objectAllocations',
		'allocationNodesByMethod',
		'didIWalk',
		'totalAllocatedMemory',
		'numberOfAllocatorClasses'
	],
	#category : 'IllimaniProfiler-Model-Statistics',
	#package : 'IllimaniProfiler',
	#tag : 'Model-Statistics'
}

{ #category : 'instance creation' }
FinalizationStatsModel class >> on: objectAllocations [

	^ self new
		  objectAllocations: objectAllocations;
		  yourself
]

{ #category : 'accessing - statistics' }
FinalizationStatsModel >> allocationsByMethod [

	didIWalk ifFalse: [ self walkAllocations ].
	^ allocationNodesByMethod sortedByTotalAllocations
]

{ #category : 'initialization' }
FinalizationStatsModel >> initialize [

	super initialize.
	allocationNodesByMethod := GroupedAllocationsByAllocatorCollection new.
	didIWalk := false
]

{ #category : 'accessing - statistics' }
FinalizationStatsModel >> numberOfAllocatorClasses [

	didIWalk ifFalse: [ self walkAllocations ].
	^ numberOfAllocatorClasses
]

{ #category : 'accessing - statistics' }
FinalizationStatsModel >> numberOfAllocatorMethods [

	^ self allocationsByMethod size
]

{ #category : 'accessing' }
FinalizationStatsModel >> objectAllocations [

	^ objectAllocations
]

{ #category : 'accessing' }
FinalizationStatsModel >> objectAllocations: anObject [

	objectAllocations := anObject
]

{ #category : 'accessing - statistics' }
FinalizationStatsModel >> timeDifferenceBetweenFirstAndLastAllocation [

	^ self objectAllocations last initializationTime - self objectAllocations first initializationTime
]

{ #category : 'accessing - statistics' }
FinalizationStatsModel >> topNAllocationsByMethod: n [

	| allocationsOrderedByMethod |
	allocationsOrderedByMethod := self allocationsByMethod.
	^ allocationsOrderedByMethod first: (n min: allocationsOrderedByMethod size)
]

{ #category : 'accessing - statistics' }
FinalizationStatsModel >> totalAllocatedMemory [

	didIWalk ifFalse: [ self walkAllocations ].
	^ totalAllocatedMemory
]

{ #category : 'accessing - statistics' }
FinalizationStatsModel >> totalAllocatedObjects [

	^ objectAllocations size
]

{ #category : 'calculating' }
FinalizationStatsModel >> walkAllocations [

	objectAllocations do: [ :allocationHolder |
		allocationNodesByMethod
			updateAllocationForAllocator: allocationHolder allocationSite
			allocation: allocationHolder ].
	
	totalAllocatedMemory := objectAllocations
		inject: 0
		into: [ :sum : elem | sum + elem sizeInBytes ].
		
	numberOfAllocatorClasses := (allocationNodesByMethod sortedByTotalAllocations
		collect: [ :e | e allocator methodClass ] as: Set) size.

	didIWalk := true
]
