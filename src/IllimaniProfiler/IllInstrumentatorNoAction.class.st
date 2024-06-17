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
