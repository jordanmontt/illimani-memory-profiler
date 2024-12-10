Class {
	#name : 'IllStatisticsModel',
	#superclass : 'Object',
	#instVars : [
		'objectAllocations',
		'didIWalk',
		'totalAllocatedMemory',
		'totalProfiledTime',
		'allocationNodesByLifetime',
		'allocationNodesByAllocationSite',
		'allocationsByAllocatedObject'
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
IllStatisticsModel >> allocationsByAllocatedObject [

	didIWalk ifFalse: [ self walkAllocations ].
	^ allocationsByAllocatedObject
]

{ #category : 'accessing - statistics' }
IllStatisticsModel >> allocationsByAllocationSite [

	didIWalk ifFalse: [ self walkAllocations ].
	^ allocationNodesByAllocationSite sortedByTotalAllocations
]

{ #category : 'accessing - statistics' }
IllStatisticsModel >> allocationsByLifetime [

	didIWalk ifFalse: [ self walkAllocations ].
	^ allocationNodesByLifetime ifNil: [ allocationNodesByLifetime := allocationNodesByAllocationSite sortedByLifetime ]
]

{ #category : 'initialization' }
IllStatisticsModel >> initialize [

	super initialize.
	allocationNodesByAllocationSite := IllGroupedAllocations new.
	allocationsByAllocatedObject := Dictionary new: 1000 "To avoid rehashing".
	didIWalk := false
]

{ #category : 'accessing - statistics' }
IllStatisticsModel >> numberOfAllocationSites [

	^ self allocationsByAllocationSite size
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
IllStatisticsModel >> topNAllocationsByMethod: n [

	| allocationsOrderedByMethod |
	allocationsOrderedByMethod := self allocationsByAllocationSite.
	^ allocationsOrderedByMethod first: (n min: allocationsOrderedByMethod size)
]

{ #category : 'accessing - statistics' }
IllStatisticsModel >> totalAllocatedMemory [

	didIWalk ifFalse: [ self walkAllocations ].
	^ totalAllocatedMemory
]

{ #category : 'accessing - statistics' }
IllStatisticsModel >> totalAllocations [

	^ objectAllocations size
]

{ #category : 'accessing' }
IllStatisticsModel >> totalProfiledTime: totalTime [

	totalProfiledTime := totalTime
]

{ #category : 'calculating' }
IllStatisticsModel >> walkAllocations [

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

	"totalAllocatedMemory := objectAllocations
		inject: 0
		into: [ :sum :elem | sum + elem sizeInBytes ]."
	totalAllocatedMemory := objectAllocations sum: #sizeInBytes.

	didIWalk := true
]
