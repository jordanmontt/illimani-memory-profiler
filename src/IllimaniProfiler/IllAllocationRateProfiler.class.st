Class {
	#name : 'IllAllocationRateProfiler',
	#superclass : 'IllAbstractProfiler',
	#instVars : [
		'totalAllocatedMemory',
		'numberOfAllocations'
	],
	#category : 'IllimaniProfiler-Allocation-Profiler',
	#package : 'IllimaniProfiler',
	#tag : 'Allocation-Profiler'
}

{ #category : 'exporting' }
IllAllocationRateProfiler >> exporterClass [

	self error: 'There is not an exporter class for this profiler'
]

{ #category : 'initialization' }
IllAllocationRateProfiler >> initialize [

	super initialize.
	numberOfAllocations := 0.
	totalAllocatedMemory := 0
]

{ #category : 'profiling' }
IllAllocationRateProfiler >> internalRegisterAllocation: anObject [

	numberOfAllocations := numberOfAllocations + 1.
	totalAllocatedMemory := totalAllocatedMemory + anObject sizeInMemory
]

{ #category : 'accessing' }
IllAllocationRateProfiler >> objectAllocations [

	^ 1 to: numberOfAllocations
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

	^ numberOfAllocations
]
