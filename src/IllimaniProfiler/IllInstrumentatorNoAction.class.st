"
I am the instrumentator for the no action profiler. For more info, see the no action profiler class comment
"
Class {
	#name : 'IllInstrumentatorNoAction',
	#superclass : 'IllInstrumentator',
	#category : 'IllimaniProfiler-Instrumentation',
	#package : 'IllimaniProfiler',
	#tag : 'Instrumentation'
}

{ #category : 'initialization' }
IllInstrumentatorNoAction >> initializeHandler [

	handler := IllNoActionHandler new
		profiler: self;
		yourself
]
