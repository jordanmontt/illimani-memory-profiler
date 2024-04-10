Class {
	#name : 'IllAllocationSitePlusFinalizationExporter',
	#superclass : 'IllAbstractExporter',
	#category : 'IllimaniProfiler-File-Exporters',
	#package : 'IllimaniProfiler',
	#tag : 'File-Exporters'
}

{ #category : 'exporting' }
IllAllocationSitePlusFinalizationExporter >> headerOfAllocationModel [

	^ #( #finalizationTimeInMicroSeconds #sizeInBytes #initializationTimeInMicroSeconds
	     #allocatedObjectClass #survivedScavenges #survivedFullGCs #forcedFinalization
	     #allocatorClass #allocatorMethod )
]
