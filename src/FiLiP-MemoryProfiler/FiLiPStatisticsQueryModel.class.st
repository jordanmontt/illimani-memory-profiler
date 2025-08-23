Class {
	#name : 'FiLiPStatisticsQueryModel',
	#superclass : 'Object',
	#instVars : [
		'objectAllocations',
		'didIWalk',
		'totalAllocatedMemory',
		'profiler',
		'allocationNodesByLifetime',
		'allocationNodesByAllocationSite',
		'allocationsByAllocatedObject'
	],
	#category : 'FiLiP-MemoryProfiler-QueryModel',
	#package : 'FiLiP-MemoryProfiler',
	#tag : 'QueryModel'
}

{ #category : 'instance creation' }
FiLiPStatisticsQueryModel class >> onProfiler: aProfiler [

    ^ self new
          objectAllocations: aProfiler objectAllocations;
          profiler: aProfiler;
          yourself
]

{ #category : 'accessing - statistics' }
FiLiPStatisticsQueryModel >> allocatedObjectTypes [

    ^ objectAllocations collect: #allocatedObjectClass as: Set
]

{ #category : 'accessing - statistics' }
FiLiPStatisticsQueryModel >> allocationsByAllocatedObject [

	didIWalk ifFalse: [ self walkAllocations ].
	^ allocationsByAllocatedObject
]

{ #category : 'accessing - statistics' }
FiLiPStatisticsQueryModel >> allocationsByAllocationSite [

	didIWalk ifFalse: [ self walkAllocations ].
	^ allocationNodesByAllocationSite sortedByTotalAllocations
]

{ #category : 'accessing - statistics' }
FiLiPStatisticsQueryModel >> allocationsByLifetime [

	didIWalk ifFalse: [ self walkAllocations ].
	^ allocationNodesByLifetime ifNil: [ allocationNodesByLifetime := allocationNodesByAllocationSite sortedByLifetime ]
]

{ #category : 'accessing - statistics' }
FiLiPStatisticsQueryModel >> averageRelativeLifetime [

    | relativeLifetimes |
    relativeLifetimes := objectAllocations collect: [ :sample |
    			(sample lifetime min: profiler totalTime) / profiler totalTime ].
    ^ relativeLifetimes average
]

{ #category : 'accessing - statistics' }
FiLiPStatisticsQueryModel >> averageSizeInMemory [

    ^ self totalAllocatedMemory / self totalAllocations
]

{ #category : 'initialization' }
FiLiPStatisticsQueryModel >> initialize [

	super initialize.
	allocationNodesByAllocationSite := IllGroupedAllocations new.
	allocationsByAllocatedObject := Dictionary new: 1000 "To avoid rehashing".
	didIWalk := false
]

{ #category : 'accessing - statistics' }
FiLiPStatisticsQueryModel >> numberOfAllocationSites [

	^ self allocationsByAllocationSite size
]

{ #category : 'accessing' }
FiLiPStatisticsQueryModel >> objectAllocations [

	^ objectAllocations
]

{ #category : 'accessing' }
FiLiPStatisticsQueryModel >> objectAllocations: anObject [

	objectAllocations := anObject
]

{ #category : 'accessing' }
FiLiPStatisticsQueryModel >> profiler: aProfiler [

    profiler := aProfiler
]

{ #category : 'accessing - statistics' }
FiLiPStatisticsQueryModel >> topNAllocationsByMethod: n [

	| allocationsOrderedByMethod |
	allocationsOrderedByMethod := self allocationsByAllocationSite.
	^ allocationsOrderedByMethod first: (n min: allocationsOrderedByMethod size)
]

{ #category : 'accessing - statistics' }
FiLiPStatisticsQueryModel >> totalAllocatedMemory [

	didIWalk ifFalse: [ self walkAllocations ].
	^ totalAllocatedMemory
]

{ #category : 'accessing - statistics' }
FiLiPStatisticsQueryModel >> totalAllocations [

	^ objectAllocations size
]

{ #category : 'calculating' }
FiLiPStatisticsQueryModel >> walkAllocations [

	objectAllocations do: [ :illEphemeron |
		allocationNodesByAllocationSite
			updateAllocationForKey: illEphemeron allocationSite
			allocation: illEphemeron.

		(allocationsByAllocatedObject
			 at: illEphemeron allocatedObjectClass
			 ifAbsentPut: [ OrderedCollection new ]) add: illEphemeron ].

	allocationsByAllocatedObject := allocationsByAllocatedObject associations.
	allocationsByAllocatedObject := allocationsByAllocatedObject sort: [ :a :b |
		a value size > b value size ].

	totalAllocatedMemory := objectAllocations sum: #sizeInBytes.

	didIWalk := true
]
