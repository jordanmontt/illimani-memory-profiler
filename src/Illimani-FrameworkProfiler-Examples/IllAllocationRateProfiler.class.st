"
I am an allocation rate profiler. What I do is to only *count* the number of allocated objects by inscreasing a counter. Nothing more.
"
Class {
	#name : 'IllAllocationRateProfiler',
	#superclass : 'IllAbstractProfiler',
	#instVars : [
		'totalAllocatedMemory',
		'numberOfAllocations'
	],
	#category : 'Illimani-FrameworkProfiler-Examples-Allocation-Rate',
	#package : 'Illimani-FrameworkProfiler-Examples',
	#tag : 'Allocation-Rate'
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

{ #category : 'accessing' }
IllAllocationRateProfiler >> totalAllocatedMemory [

	^ totalAllocatedMemory
]

{ #category : 'accessing' }
IllAllocationRateProfiler >> totalAllocations [

	^ numberOfAllocations
]
