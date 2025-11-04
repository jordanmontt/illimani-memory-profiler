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
	#category : 'Illimani-FrameworkProfiler-Examples-Allocation-Rate-Profiler',
	#package : 'Illimani-FrameworkProfiler-Examples',
	#tag : 'Allocation-Rate-Profiler'
}

{ #category : 'exporting' }
IllAllocationRateProfiler >> exporterClass [

	^ IllAllocationRateExporter
]

{ #category : 'initialization' }
IllAllocationRateProfiler >> initialize [

	super initialize.
	numberOfAllocations := 0.
	totalAllocatedMemory := 0.

	"Capture all allocations"
	self samplingRate: 1
]

{ #category : 'profiling' }
IllAllocationRateProfiler >> internalRegisterAllocation: anObject [
    "Do nothing as registerAllocation: was overridden"

    
]

{ #category : 'accessing' }
IllAllocationRateProfiler >> objectAllocations [

	^ 1 to: numberOfAllocations
]

{ #category : 'profiling' }
IllAllocationRateProfiler >> registerAllocation: anObject [

    numberOfAllocations := numberOfAllocations + 1.
    totalAllocatedMemory := totalAllocatedMemory + anObject sizeInMemory
]

{ #category : 'accessing' }
IllAllocationRateProfiler >> totalAllocatedMemory [

	^ totalAllocatedMemory
]

{ #category : 'accessing' }
IllAllocationRateProfiler >> totalAllocations [

	^ numberOfAllocations
]

{ #category : 'construction-UIManager' }
IllAllocationRateProfiler >> uiClass [

	^ IllAllocationRateProfilerUI
]
