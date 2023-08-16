"
An IllimaniProfilerMpHandlerTest is a test class for testing the behavior of IllimaniProfilerMpHandler
"
Class {
	#name : #IllimaniProfilerMpHandlerTest,
	#superclass : #TestCase,
	#instVars : [
		'handler'
	],
	#category : #'IllimaniAllocationProfiler-Tests-Profiler'
}

{ #category : #running }
IllimaniProfilerMpHandlerTest >> setUp [

	super setUp.

	handler := IllimaniProfilerMpHandler new
]

{ #category : #tests }
IllimaniProfilerMpHandlerTest >> testCaptureAllObjects [

	handler captureAllObjects.

	self assert: (handler shouldICaptureTheObject: Point new).
	self assert: (handler shouldICaptureTheObject: Point).
	self assert: (handler shouldICaptureTheObject: Color new).
	self assert: (handler shouldICaptureTheObject: nil)
]

{ #category : #tests }
IllimaniProfilerMpHandlerTest >> testCaptureAllObjectsAndIgnoringClasses [

	handler captureAllObjects.
	handler objectsToIgnore: { Point . ByteString }.

	self deny: (handler shouldICaptureTheObject: Point new).
	self deny: (handler shouldICaptureTheObject: ByteString new).
	self assert: (handler shouldICaptureTheObject: Point).
	self assert: (handler shouldICaptureTheObject: Color new).
	self assert: (handler shouldICaptureTheObject: nil)
]

{ #category : #tests }
IllimaniProfilerMpHandlerTest >> testObjectsToCapture [

	handler objectsToCapture: { Color . Point }.
	self assert: (handler shouldICaptureTheObject: Point new).
	self assert: (handler shouldICaptureTheObject: Color new).
	self deny: (handler shouldICaptureTheObject: ByteString new).
]

{ #category : #tests }
IllimaniProfilerMpHandlerTest >> testObjectsToIgnore [

	handler objectsToIgnore: { Point . ByteString }.
	handler captureAllObjects.
	self deny: (handler shouldICaptureTheObject: Point new).
	self deny: (handler shouldICaptureTheObject: ByteString new).
	self assert: (handler shouldICaptureTheObject: Color new).
	self assert: (handler shouldICaptureTheObject: nil).
	self assert: (handler shouldICaptureTheObject: 5).
]

{ #category : #tests }
IllimaniProfilerMpHandlerTest >> testShouldICaptureTheObject [

	handler objectsToCapture: { Color . Point }.
	self assert: (handler shouldICaptureTheObject: Point new).
	self assert: (handler shouldICaptureTheObject: Color new)
]
