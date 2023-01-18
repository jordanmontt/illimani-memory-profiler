"
I am a handler that register when an object of type Dictionary is allocated.
"
Class {
	#name : #MpDictionaryAllocationProfilerHandler,
	#superclass : #MpObjectAllocationProfilerHandler,
	#category : #AllocationProfiler
}

{ #category : #printing }
MpDictionaryAllocationProfilerHandler class >> prettyName [

	^ 'Dictionaries'
]

{ #category : #evaluating }
MpDictionaryAllocationProfilerHandler >> classesToRegister [

	^ { Dictionary }
]
