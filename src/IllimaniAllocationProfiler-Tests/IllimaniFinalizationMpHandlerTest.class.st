Class {
	#name : 'IllimaniFinalizationMpHandlerTest',
	#superclass : 'TestCase',
	#instVars : [
		'handler'
	],
	#category : 'IllimaniAllocationProfiler-Tests-Profiler',
	#package : 'IllimaniAllocationProfiler-Tests',
	#tag : 'Profiler'
}

{ #category : 'running' }
IllimaniFinalizationMpHandlerTest >> setUp [

	super setUp.
	handler := IllimaniFinalizationMpHandler new
]

{ #category : 'tests' }
IllimaniFinalizationMpHandlerTest >> testSamplingRate [

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
