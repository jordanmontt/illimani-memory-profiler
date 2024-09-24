Class {
	#name : 'IllMemoryProfilerExporter',
	#superclass : 'IllAbstractExporter',
	#category : 'IllimaniProfiler-File-Exporters',
	#package : 'IllimaniProfiler',
	#tag : 'File-Exporters'
}

{ #category : 'instance creation' }
IllMemoryProfilerExporter class >> on: aProfiler [

	^ self new
		profiler: aProfiler;
		yourself
]

{ #category : 'exporting' }
IllMemoryProfilerExporter >> headerOfAllocationModel [

	^ #( #finalizationTimeInMicroSeconds #sizeInBytes #initializationTimeInMicroSeconds
	     #allocatedObjectClass #survivedScavenges #survivedFullGCs #allocatorMethod #allocatorMethodByte )
]

{ #category : 'exporting' }
IllMemoryProfilerExporter >> jsonDictionary [

	| avgLifetimes |
	avgLifetimes := ((profiler objectAllocations sum: #lifetime)
	                 / profiler objectAllocations size) asFloat.

	^ super jsonDictionary
		add: 'averageLifetimes' -> avgLifetimes;
		yourself
]
