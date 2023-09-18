Class {
	#name : 'IllimaniFinalizationMpHandlerTest',
	#superclass : 'TestCase',
	#instVars : [
		'handler',
		'handlerClass'
	],
	#category : 'IllimaniAllocationProfiler-Tests-Profiler',
	#package : 'IllimaniAllocationProfiler-Tests',
	#tag : 'Profiler'
}

{ #category : 'building suites' }
IllimaniFinalizationMpHandlerTest class >> testParameters [

	^ ParametrizedTestMatrix new
		  addCase: { (#handlerClass -> IllimaniFinalizationMpHandler) };
		  addCase: { (#handlerClass -> IllimaniProfilerMpHandler) };
		  yourself
]

{ #category : 'running' }
IllimaniFinalizationMpHandlerTest >> setUp [

	super setUp.
	handler := IllimaniFinalizationMpHandler new
]

{ #category : 'tests' }
IllimaniFinalizationMpHandlerTest >> testCleanProfilingData [

	handler
		samplingRate: 20;
		samplingCounter: 22.

	handler cleanObjectAllocations.

	self assert: handler objectAllocations isEmpty.
	self assert: handler samplingRate closeTo: 100 / 20.
	self assert: handler samplingCounter equals: 0
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
