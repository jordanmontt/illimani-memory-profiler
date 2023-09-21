"
An IllimaniProfilerMpHandlerTest is a test class for testing the behavior of IllimaniProfilerMpHandler
"
Class {
	#name : 'IllProfilerMpHandlerTest',
	#superclass : 'TestCase',
	#instVars : [
		'handler'
	],
	#category : 'IllimaniAllocationProfiler-Tests-Profiler',
	#package : 'IllimaniAllocationProfiler-Tests',
	#tag : 'Profiler'
}

{ #category : 'running' }
IllProfilerMpHandlerTest >> setUp [

	super setUp.
	handler := IllAllocationProfilerMpHandler new
]

{ #category : 'tests' }
IllProfilerMpHandlerTest >> testCaptureAllObjects [

	handler captureAllObjects.

	self assert: (handler shouldICaptureTheObject: Point new).
	self assert: (handler shouldICaptureTheObject: Point).
	self assert: (handler shouldICaptureTheObject: Color new).
	self assert: (handler shouldICaptureTheObject: nil)
]

{ #category : 'tests' }
IllProfilerMpHandlerTest >> testCaptureAllObjectsAndIgnoringClasses [

	handler captureAllObjects.
	handler objectsToIgnore: { Point . ByteString }.

	self deny: (handler shouldICaptureTheObject: Point new).
	self deny: (handler shouldICaptureTheObject: ByteString new).
	self assert: (handler shouldICaptureTheObject: Point).
	self assert: (handler shouldICaptureTheObject: Color new).
	self assert: (handler shouldICaptureTheObject: nil)
]

{ #category : 'tests' }
IllProfilerMpHandlerTest >> testCleanProfilingData [

	handler
		objectsToCapture: { Color . Point };
		objectsToIgnore: { ByteString };
		samplingRate: 20;
		samplingCounter: 22.

	handler cleanObjectAllocations.

	self assert: handler objectAllocations isEmpty.
	self assert: handler samplingRate closeTo: 100 / 20.
	self assert: handler samplingCounter equals: 0.
	self assertCollection: handler objectsToCapture hasSameElements: { Color . Point }.
	self assertCollection: handler objectsToIgnore hasSameElements: { ByteString }
]

{ #category : 'tests' }
IllProfilerMpHandlerTest >> testObjectsToCapture [

	handler objectsToCapture: { Color . Point }.
	self assert: (handler shouldICaptureTheObject: Point new).
	self assert: (handler shouldICaptureTheObject: Color new).
	self deny: (handler shouldICaptureTheObject: ByteString new).
]

{ #category : 'tests' }
IllProfilerMpHandlerTest >> testObjectsToIgnore [

	handler objectsToIgnore: { Point . ByteString }.
	handler captureAllObjects.
	self deny: (handler shouldICaptureTheObject: Point new).
	self deny: (handler shouldICaptureTheObject: ByteString new).
	self assert: (handler shouldICaptureTheObject: Color new).
	self assert: (handler shouldICaptureTheObject: nil).
	self assert: (handler shouldICaptureTheObject: 5).
]

{ #category : 'tests' }
IllProfilerMpHandlerTest >> testSamplingRate [

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

{ #category : 'tests' }
IllProfilerMpHandlerTest >> testShouldICaptureTheObject [

	handler objectsToCapture: { Color . Point }.
	self assert: (handler shouldICaptureTheObject: Point new).
	self assert: (handler shouldICaptureTheObject: Color new)
]
