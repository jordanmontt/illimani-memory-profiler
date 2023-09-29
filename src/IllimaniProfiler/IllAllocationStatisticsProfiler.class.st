Class {
	#name : 'IllAllocationStatisticsProfiler',
	#superclass : 'IllAbstractProfiler',
	#instVars : [
		'allocationsRegistry',
		'objectAllocations'
	],
	#category : 'IllimaniProfiler-Allocation-Profiler',
	#package : 'IllimaniProfiler',
	#tag : 'Allocation-Profiler'
}

{ #category : 'initialization' }
IllAllocationStatisticsProfiler >> initialize [

	super initialize.
	allocationsRegistry := OrderedCollection new: 3000000
]

{ #category : 'profiling' }
IllAllocationStatisticsProfiler >> internalRegisterAllocation: anObject [

	allocationsRegistry add: anObject class -> anObject sizeInMemory
]

{ #category : 'accessing' }
IllAllocationStatisticsProfiler >> objectAllocations [

	objectAllocations ifNil: [
		objectAllocations := allocationsRegistry collect: [ :assoc |
			AllocationBasicInfoModel new
				allocatedObjectClass: assoc key;
				sizeInBytes: assoc value;
				yourself ] ].
	^ objectAllocations
]

{ #category : 'accessing - statistics' }
IllAllocationStatisticsProfiler >> stats [

	^ self
]

{ #category : 'accessing' }
IllAllocationStatisticsProfiler >> totalAllocatedMemory [

	^ self objectAllocations sum: #sizeInBytes
]

{ #category : 'accessing' }
IllAllocationStatisticsProfiler >> totalAllocatedObjects [

	^ allocationsRegistry size
]
