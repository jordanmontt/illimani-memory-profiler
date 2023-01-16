Class {
	#name : #MpDictionaryAllocationProfilerHandler,
	#superclass : #MpObjectAllocationProfilerHandler,
	#category : #AllocationProfiler
}

{ #category : #evaluating }
MpDictionaryAllocationProfilerHandler >> classesToRegister [

	^ { Dictionary }
]
