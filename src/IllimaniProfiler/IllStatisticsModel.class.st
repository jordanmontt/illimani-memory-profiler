Class {
	#name : 'IllStatisticsModel',
	#superclass : 'Object',
	#instVars : [
		'objectAllocations',
		'allocationNodesByMethod',
		'didIWalk',
		'totalAllocatedMemory',
		'numberOfAllocatorClasses',
		'totalProfiledTime',
		'allocationNodesByLifetime'
	],
	#category : 'IllimaniProfiler-Model-Statistics',
	#package : 'IllimaniProfiler',
	#tag : 'Model-Statistics'
}

{ #category : 'instance creation' }
IllStatisticsModel class >> objectAllocations: objectAllocations totalProfiledTime: totalTime [

	^ self new
		  objectAllocations: objectAllocations;
		  totalProfiledTime: totalTime;
		  yourself
]

{ #category : 'instance creation' }
IllStatisticsModel class >> on: objectAllocations [

	^ self new
		  objectAllocations: objectAllocations;
		  yourself
]

{ #category : 'accessing - statistics' }
IllStatisticsModel >> allocatedMemoryRatePerSecond [

	^ self totalAllocatedMemory
	  / (Duration microSeconds: totalProfiledTime) totalSeconds asFloat
]

{ #category : 'accessing - statistics' }
IllStatisticsModel >> allocationRatePerSecond [

	^ self totalAllocatedObjects
	  / (Duration microSeconds: totalProfiledTime) totalSeconds asFloat
]

{ #category : 'accessing - statistics' }
IllStatisticsModel >> allocationsByLifetime [

	didIWalk ifFalse: [ self walkAllocations ].
	^ allocationNodesByLifetime ifNil: [ allocationNodesByLifetime := allocationNodesByMethod sortedByLifetime ]
]

{ #category : 'accessing - statistics' }
IllStatisticsModel >> allocationsByMethod [

	didIWalk ifFalse: [ self walkAllocations ].
	^ allocationNodesByMethod sortedByTotalAllocations
]

{ #category : 'initialization' }
IllStatisticsModel >> initialize [

	super initialize.
	allocationNodesByMethod := GroupedAllocationsByAllocatorCollection new.
	didIWalk := false
]

{ #category : 'accessing - statistics' }
IllStatisticsModel >> numberOfAllocatorClasses [

	didIWalk ifFalse: [ self walkAllocations ].
	^ numberOfAllocatorClasses
]

{ #category : 'accessing - statistics' }
IllStatisticsModel >> numberOfAllocatorMethods [

	^ self allocationsByMethod size
]

{ #category : 'accessing' }
IllStatisticsModel >> objectAllocations [

	^ objectAllocations
]

{ #category : 'accessing' }
IllStatisticsModel >> objectAllocations: anObject [

	objectAllocations := anObject
]

{ #category : 'accessing - statistics' }
IllStatisticsModel >> timeDifferenceBetweenFirstAndLastAllocation [

	^ self objectAllocations last initializationTime - self objectAllocations first initializationTime
]

{ #category : 'accessing - statistics' }
IllStatisticsModel >> topNAllocationsByMethod: n [

	| allocationsOrderedByMethod |
	allocationsOrderedByMethod := self allocationsByMethod.
	^ allocationsOrderedByMethod first: (n min: allocationsOrderedByMethod size)
]

{ #category : 'accessing - statistics' }
IllStatisticsModel >> totalAllocatedMemory [

	didIWalk ifFalse: [ self walkAllocations ].
	^ totalAllocatedMemory
]

{ #category : 'accessing - statistics' }
IllStatisticsModel >> totalAllocatedObjects [

	^ objectAllocations size
]

{ #category : 'accessing' }
IllStatisticsModel >> totalProfiledTime: totalTime [

	totalProfiledTime := totalTime
]

{ #category : 'calculating' }
IllStatisticsModel >> walkAllocations [

	objectAllocations do: [ :allocationHolder |
		allocationNodesByMethod
			updateAllocationForAllocator: allocationHolder allocatorMethod
			allocation: allocationHolder ].

	totalAllocatedMemory := objectAllocations
		inject: 0
		into: [ :sum : elem | sum + elem sizeInBytes ].

	numberOfAllocatorClasses := (objectAllocations collect: #allocatorClass as: Set) size.

	didIWalk := true
]
