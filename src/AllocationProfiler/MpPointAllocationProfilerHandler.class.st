"
I am a handler that register when an object of type Point is allocated.
"
Class {
	#name : #MpPointAllocationProfilerHandler,
	#superclass : #MpObjectAllocationProfilerHandler,
	#category : #AllocationProfiler
}

{ #category : #evaluating }
MpPointAllocationProfilerHandler >> classesToRegister [

	^ { Point }
]
