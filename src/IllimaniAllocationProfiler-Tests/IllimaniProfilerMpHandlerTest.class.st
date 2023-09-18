"
An IllimaniProfilerMpHandlerTest is a test class for testing the behavior of IllimaniProfilerMpHandler
"
Class {
	#name : 'IllimaniProfilerMpHandlerTest',
	#superclass : 'TestCase',
	#instVars : [
		'handler'
	],
	#category : 'IllimaniAllocationProfiler-Tests-Profiler',
	#package : 'IllimaniAllocationProfiler-Tests',
	#tag : 'Profiler'
}

{ #category : 'running' }
IllimaniProfilerMpHandlerTest >> setUp [

	super setUp.
	handler := IllimaniProfilerMpHandler new
]

{ #category : 'tests' }
IllimaniProfilerMpHandlerTest >> testCaptureAllObjects [

	handler captureAllObjects.

	self assert: (handler shouldICaptureTheObject: Point new).
	self assert: (handler shouldICaptureTheObject: Point).
	self assert: (handler shouldICaptureTheObject: Color new).
	self assert: (handler shouldICaptureTheObject: nil)
]

{ #category : 'tests' }
IllimaniProfilerMpHandlerTest >> testCaptureAllObjectsAndIgnoringClasses [

	handler captureAllObjects.
	handler objectsToIgnore: { Point . ByteString }.

	self deny: (handler shouldICaptureTheObject: Point new).
	self deny: (handler shouldICaptureTheObject: ByteString new).
	self assert: (handler shouldICaptureTheObject: Point).
	self assert: (handler shouldICaptureTheObject: Color new).
	self assert: (handler shouldICaptureTheObject: nil)
]

{ #category : 'tests' }
IllimaniProfilerMpHandlerTest >> testCleanProfilingData [

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
IllimaniProfilerMpHandlerTest >> testObjectsToCapture [

	handler objectsToCapture: { Color . Point }.
	self assert: (handler shouldICaptureTheObject: Point new).
	self assert: (handler shouldICaptureTheObject: Color new).
	self deny: (handler shouldICaptureTheObject: ByteString new).
]

{ #category : 'tests' }
IllimaniProfilerMpHandlerTest >> testObjectsToIgnore [

	handler objectsToIgnore: { Point . ByteString }.
	handler captureAllObjects.
	self deny: (handler shouldICaptureTheObject: Point new).
	self deny: (handler shouldICaptureTheObject: ByteString new).
	self assert: (handler shouldICaptureTheObject: Color new).
	self assert: (handler shouldICaptureTheObject: nil).
	self assert: (handler shouldICaptureTheObject: 5).
]

{ #category : 'tests' }
IllimaniProfilerMpHandlerTest >> testSamplingRate [

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
IllimaniProfilerMpHandlerTest >> testShouldICaptureTheObject [

	handler objectsToCapture: { Color . Point }.
	self assert: (handler shouldICaptureTheObject: Point new).
	self assert: (handler shouldICaptureTheObject: Color new)
]
