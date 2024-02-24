Class {
	#name : 'IllFinalizationExporter',
	#superclass : 'IllAbstractExporter',
	#category : 'IllimaniProfiler-File-Exporters',
	#package : 'IllimaniProfiler',
	#tag : 'File-Exporters'
}

{ #category : 'instance creation' }
IllFinalizationExporter class >> on: aProfiler [

	^ self new
		profiler: aProfiler;
		yourself
]

{ #category : 'exporting' }
IllFinalizationExporter >> headerOfAllocationModel [ 

	^ #( #finalizationTimeInMicroSeconds #sizeInBytes #initializationTimeInMicroSeconds #allocatedObjectClass
	     #survivedScavenges #survivedFullGCs #forcedFinalization )
]
