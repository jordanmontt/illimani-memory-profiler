"
I am a handler that register when an object of type color is allocated.
"
Class {
	#name : #MpColorAllocationProfilerHandler,
	#superclass : #MpObjectAllocationProfilerHandler,
	#category : #AllocationProfiler
}

{ #category : #printing }
MpColorAllocationProfilerHandler class >> prettyName [

	^ 'Colors'
]

{ #category : #evaluating }
MpColorAllocationProfilerHandler >> classesToRegister [

	^ { Color }
]
