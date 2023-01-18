"
I am a handler that register when an object of type Point is allocated.
"
Class {
	#name : #MpPointAllocationProfilerHandler,
	#superclass : #MpObjectAllocationProfilerHandler,
	#category : #AllocationProfiler
}

{ #category : #printing }
MpPointAllocationProfilerHandler class >> prettyName [

	^ 'Points'
]

{ #category : #evaluating }
MpPointAllocationProfilerHandler >> classesToRegister [

	^ { Point }
]
