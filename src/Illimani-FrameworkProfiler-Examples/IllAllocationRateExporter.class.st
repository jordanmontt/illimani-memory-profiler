Class {
	#name : 'IllAllocationRateExporter',
	#superclass : 'IllSimpleExporter',
	#category : 'Illimani-FrameworkProfiler-Examples-Allocation-Rate-Profiler',
	#package : 'Illimani-FrameworkProfiler-Examples',
	#tag : 'Allocation-Rate-Profiler'
}

{ #category : 'exporting' }
IllAllocationRateExporter >> jsonDictionary [

	^ super jsonDictionary
		  add: 'totalAllocatedMemory' -> profiler totalAllocatedMemory;
		  add: 'totalAllocations' -> profiler totalAllocations;
		  yourself
]
