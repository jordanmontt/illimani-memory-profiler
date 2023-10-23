Class {
	#name : 'IllAllocationRateProfiler',
	#superclass : 'IllAbstractProfiler',
	#instVars : [
		'numberOfAllocatios',
		'totalAllocatedMemory',
		'objectAllocations'
	],
	#category : 'IllimaniProfiler-Allocation-Profiler',
	#package : 'IllimaniProfiler',
	#tag : 'Allocation-Profiler'
}

{ #category : 'initialization' }
IllAllocationRateProfiler >> initialize [

	super initialize.
	numberOfAllocatios := 0.
	totalAllocatedMemory := 0
]

{ #category : 'profiling' }
IllAllocationRateProfiler >> internalRegisterAllocation: anObject [

	numberOfAllocatios := numberOfAllocatios + 1.
	totalAllocatedMemory := totalAllocatedMemory + anObject sizeInMemory
]

{ #category : 'accessing' }
IllAllocationRateProfiler >> objectAllocations [

	objectAllocations ifNil: [
		objectAllocations := (1 to: numberOfAllocatios) collect: [ :assoc |
			AllocationBasicInfoModel new
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

	^ numberOfAllocatios
]
