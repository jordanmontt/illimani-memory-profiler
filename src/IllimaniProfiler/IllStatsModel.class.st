Class {
	#name : 'IllStatsModel',
	#superclass : 'Object',
	#instVars : [
		'objectAllocations',
		'allocationNodesByMethod',
		'didIWalk',
		'totalAllocatedMemory',
		'numberOfAllocatorClasses',
		'totalProfiledTime'
	],
	#category : 'IllimaniProfiler-Model-Statistics',
	#package : 'IllimaniProfiler',
	#tag : 'Model-Statistics'
}

{ #category : 'instance creation' }
IllStatsModel class >> objectAllocations: objectAllocations totalProfiledTime: totalTime [

	^ self new
		  objectAllocations: objectAllocations;
		  totalProfiledTime: totalTime;
		  yourself
]

{ #category : 'instance creation' }
IllStatsModel class >> on: objectAllocations [

	^ self new
		  objectAllocations: objectAllocations;
		  yourself
]

{ #category : 'accessing - statistics' }
IllStatsModel >> allocatedMemoryRatePerSecond [

	^ self totalAllocatedMemory
	  / (Duration microSeconds: totalProfiledTime) totalSeconds asFloat
]

{ #category : 'accessing - statistics' }
IllStatsModel >> allocationRatePerSecond [

	^ self totalAllocatedObjects
	  / (Duration microSeconds: totalProfiledTime) totalSeconds asFloat
]

{ #category : 'accessing - statistics' }
IllStatsModel >> allocationsByMethod [

	didIWalk ifFalse: [ self walkAllocations ].
	^ allocationNodesByMethod sortedByTotalAllocations
]

{ #category : 'initialization' }
IllStatsModel >> initialize [

	super initialize.
	allocationNodesByMethod := GroupedAllocationsByAllocatorCollection new.
	didIWalk := false
]

{ #category : 'accessing - statistics' }
IllStatsModel >> numberOfAllocatorClasses [

	didIWalk ifFalse: [ self walkAllocations ].
	^ numberOfAllocatorClasses
]

{ #category : 'accessing - statistics' }
IllStatsModel >> numberOfAllocatorMethods [

	^ self allocationsByMethod size
]

{ #category : 'accessing' }
IllStatsModel >> objectAllocations [

	^ objectAllocations
]

{ #category : 'accessing' }
IllStatsModel >> objectAllocations: anObject [

	objectAllocations := anObject
]

{ #category : 'accessing - statistics' }
IllStatsModel >> timeDifferenceBetweenFirstAndLastAllocation [

	^ self objectAllocations last initializationTime - self objectAllocations first initializationTime
]

{ #category : 'accessing - statistics' }
IllStatsModel >> topNAllocationsByMethod: n [

	| allocationsOrderedByMethod |
	allocationsOrderedByMethod := self allocationsByMethod.
	^ allocationsOrderedByMethod first: (n min: allocationsOrderedByMethod size)
]

{ #category : 'accessing - statistics' }
IllStatsModel >> totalAllocatedMemory [

	didIWalk ifFalse: [ self walkAllocations ].
	^ totalAllocatedMemory
]

{ #category : 'accessing - statistics' }
IllStatsModel >> totalAllocatedObjects [

	^ objectAllocations size
]

{ #category : 'accessing' }
IllStatsModel >> totalProfiledTime: totalTime [

	totalProfiledTime := totalTime
]

{ #category : 'calculating' }
IllStatsModel >> walkAllocations [

	objectAllocations do: [ :allocationHolder |
		allocationNodesByMethod
			updateAllocationForAllocator: allocationHolder allocationSite
			allocation: allocationHolder ].

	totalAllocatedMemory := objectAllocations
		inject: 0
		into: [ :sum : elem | sum + elem sizeInBytes ].

	numberOfAllocatorClasses := (objectAllocations collect: #allocatorClass as: Set) size.

	didIWalk := true
]
