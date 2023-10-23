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

{ #category : 'accessing - statistics' }
IllAllocationRateProfiler >> stats [

	^ self
]

{ #category : 'accessing' }
IllAllocationRateProfiler >> totalAllocatedMemory [

	^ totalAllocatedMemory
]

{ #category : 'accessing' }
IllAllocationRateProfiler >> totalAllocatedObjects [

	^ numberOfAllocatios
]
