Class {
	#name : 'IllObjectLifetimesExporter',
	#superclass : 'IllAbstractExporter',
	#category : 'IllimaniProfiler-File-Exporters',
	#package : 'IllimaniProfiler',
	#tag : 'File-Exporters'
}

{ #category : 'instance creation' }
IllObjectLifetimesExporter class >> on: aProfiler [

	^ self new
		profiler: aProfiler;
		yourself
]

{ #category : 'exporting' }
IllObjectLifetimesExporter >> headerOfAllocationModel [ 

	^ #( #finalizationTimeInMicroSeconds #sizeInBytes #initializationTimeInMicroSeconds #allocatedObjectClass
	     #survivedScavenges #survivedFullGCs #forcedFinalization )
]

{ #category : 'exporting' }
IllObjectLifetimesExporter >> jsonDictionary [

	| avgLifetimes |
	avgLifetimes := ((profiler objectAllocations sum: #lifetime)
	                 / profiler objectAllocations size) asFloat.

	^ super jsonDictionary
		add: 'averageLifetimes' -> avgLifetimes;
		yourself
]
