Class {
	#name : 'IllAllocationSiteExporter',
	#superclass : 'IllAbstractExporter',
	#category : 'IllimaniProfiler-File-Exporters',
	#package : 'IllimaniProfiler',
	#tag : 'File-Exporters'
}

{ #category : 'instance creation' }
IllAllocationSiteExporter class >> on: aProfiler [

	^ self new
		profiler: aProfiler;
		yourself
]

{ #category : 'as yet unclassified' }
IllAllocationSiteExporter >> headerOfAllocationModel [

	^ #( #allocatedObjectClass #sizeInBytes #initializationTimeInMicroSeconds
	     #allocatorClass #allocatorMethod )
]
