Class {
	#name : 'IllFinalizationMpHandlerTest',
	#superclass : 'TestCase',
	#instVars : [
		'handler'
	],
	#category : 'IllimaniFinalizationProfiler-Tests',
	#package : 'IllimaniFinalizationProfiler',
	#tag : 'Tests'
}

{ #category : 'running' }
IllFinalizationMpHandlerTest >> setUp [

	super setUp.
	handler := IllFinalizationMpHandler new
]

{ #category : 'tests' }
IllFinalizationMpHandlerTest >> testSamplingRate [

	"By default, do not sample"
	self assert: handler samplingRate equals: 1.
	
	"Sample at 20%"
	handler samplingRate: 20.
	"Sample at 20% is the same as sample each 5 allocations"
	self assert: handler samplingRate equals: 5.
	
	"Do not sample. The same as sampling 100%".
	handler samplingRate: 100.
	self assert: handler samplingRate equals: 1.
]
