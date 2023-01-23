"
I will capture ALL the allocations of objects of any type.
"
Class {
	#name : #MpMegaAllocationProfilerHandler,
	#superclass : #MpObjectAllocationProfilerHandler,
	#category : #AllocationProfiler
}

{ #category : #printing }
MpMegaAllocationProfilerHandler class >> prettyName [

	^ 'All objects'
]

{ #category : #evaluating }
MpMegaAllocationProfilerHandler >> afterExecutionWithReceiver: receiver arguments: arguments returnValue: returnValue [

	objectAllocations add: (self allocationHolderForObject: returnValue).
	^ returnValue
]

{ #category : #evaluating }
MpMegaAllocationProfilerHandler >> classesToRegister [

	^ {  }
]
