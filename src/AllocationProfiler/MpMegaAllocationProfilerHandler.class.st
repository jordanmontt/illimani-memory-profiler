Class {
	#name : #MpMegaAllocationProfilerHandler,
	#superclass : #MpObjectAllocationProfilerHandler,
	#category : #AllocationProfiler
}

{ #category : #evaluating }
MpMegaAllocationProfilerHandler >> afterExecutionWithReceiver: receiver arguments: arguments returnValue: returnValue [

	objectAllocations add: (AllocationInformationHolder
		context: (self contextThatAllocatesTheObject: thisContext) copyStack
		allocatedObject: returnValue).
	^ returnValue
]

{ #category : #evaluating }
MpMegaAllocationProfilerHandler >> classesToRegister [

	^ {  }
]
