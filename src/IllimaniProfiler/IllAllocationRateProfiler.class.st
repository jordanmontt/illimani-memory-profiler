Class {
	#name : 'IllAllocationRateProfiler',
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
IllAllocationRateProfiler >> initialize [

	super initialize.
	allocationsRegistry := OrderedCollection new: 3000000
]

{ #category : 'profiling' }
IllAllocationRateProfiler >> internalRegisterAllocation: anObject [

	allocationsRegistry add: anObject class -> anObject sizeInMemory
]

{ #category : 'accessing' }
IllAllocationRateProfiler >> objectAllocations [

	objectAllocations ifNil: [
		objectAllocations := allocationsRegistry collect: [ :assoc |
			AllocationBasicInfoModel new
				allocatedObjectClass: assoc key;
				sizeInBytes: assoc value;
				yourself ] ].
	^ objectAllocations
]

{ #category : 'accessing - statistics' }
IllAllocationRateProfiler >> stats [

	^ self
]

{ #category : 'accessing' }
IllAllocationRateProfiler >> totalAllocatedMemory [

	^ self objectAllocations sum: #sizeInBytes
]

{ #category : 'accessing' }
IllAllocationRateProfiler >> totalAllocatedObjects [

	^ allocationsRegistry size
]
