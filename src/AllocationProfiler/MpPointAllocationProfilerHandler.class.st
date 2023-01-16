Class {
	#name : #MpPointAllocationProfilerHandler,
	#superclass : #MpObjectAllocationProfilerHandler,
	#category : #AllocationProfiler
}

{ #category : #evaluating }
MpPointAllocationProfilerHandler >> classesToRegister [

	^ { Point }
]
