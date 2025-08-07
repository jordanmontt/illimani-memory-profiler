Class {
	#name : 'IllStatisticsQueryModel',
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
	#category : 'IllimaniProfiler-Model-Statistics',
	#package : 'IllimaniProfiler',
	#tag : 'Model-Statistics'
}

{ #category : 'instance creation' }
IllStatisticsQueryModel class >> onProfiler: aProfiler [

    ^ self new
          objectAllocations: aProfiler objectAllocations;
          profiler: aProfiler;
          yourself
]

{ #category : 'accessing - statistics' }
IllStatisticsQueryModel >> allocatedObjectTypes [

    ^ objectAllocations collect: #allocatedObjectClass as: Set
]

{ #category : 'accessing - statistics' }
IllStatisticsQueryModel >> allocationsByAllocatedObject [

	didIWalk ifFalse: [ self walkAllocations ].
	^ allocationsByAllocatedObject
]

{ #category : 'accessing - statistics' }
IllStatisticsQueryModel >> allocationsByAllocationSite [

	didIWalk ifFalse: [ self walkAllocations ].
	^ allocationNodesByAllocationSite sortedByTotalAllocations
]

{ #category : 'accessing - statistics' }
IllStatisticsQueryModel >> allocationsByLifetime [

	didIWalk ifFalse: [ self walkAllocations ].
	^ allocationNodesByLifetime ifNil: [ allocationNodesByLifetime := allocationNodesByAllocationSite sortedByLifetime ]
]

{ #category : 'accessing - statistics' }
IllStatisticsQueryModel >> averageRelativeLifetime [

    | relativeLifetimes |
    relativeLifetimes := objectAllocations collect: [ :sample |
    			(sample lifetime min: profiler totalTime) / profiler totalTime ].
    ^ relativeLifetimes average
]

{ #category : 'accessing - statistics' }
IllStatisticsQueryModel >> averageSizeInMemory [

    ^ self totalAllocatedMemory / self totalAllocations
]

{ #category : 'initialization' }
IllStatisticsQueryModel >> initialize [

	super initialize.
	allocationNodesByAllocationSite := IllGroupedAllocations new.
	allocationsByAllocatedObject := Dictionary new: 1000 "To avoid rehashing".
	didIWalk := false
]

{ #category : 'accessing - statistics' }
IllStatisticsQueryModel >> numberOfAllocationSites [

	^ self allocationsByAllocationSite size
]

{ #category : 'accessing' }
IllStatisticsQueryModel >> objectAllocations [

	^ objectAllocations
]

{ #category : 'accessing' }
IllStatisticsQueryModel >> objectAllocations: anObject [

	objectAllocations := anObject
]

{ #category : 'accessing' }
IllStatisticsQueryModel >> profiler: aProfiler [

    profiler := aProfiler
]

{ #category : 'accessing - statistics' }
IllStatisticsQueryModel >> topNAllocationsByMethod: n [

	| allocationsOrderedByMethod |
	allocationsOrderedByMethod := self allocationsByAllocationSite.
	^ allocationsOrderedByMethod first: (n min: allocationsOrderedByMethod size)
]

{ #category : 'accessing - statistics' }
IllStatisticsQueryModel >> totalAllocatedMemory [

	didIWalk ifFalse: [ self walkAllocations ].
	^ totalAllocatedMemory
]

{ #category : 'accessing - statistics' }
IllStatisticsQueryModel >> totalAllocations [

	^ objectAllocations size
]

{ #category : 'calculating' }
IllStatisticsQueryModel >> walkAllocations [

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
