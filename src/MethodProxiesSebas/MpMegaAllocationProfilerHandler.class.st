Class {
	#name : #MpMegaAllocationProfilerHandler,
	#superclass : #MpObjectAllocationProfilerHandler,
	#category : #MethodProxiesSebas
}

{ #category : #evaluating }
MpMegaAllocationProfilerHandler >> afterExecutionWithReceiver: receiver arguments: arguments returnValue: returnValue [

	allocations add:
		(AllocationInformationHolder
			context: (self contextThatCreatesTheColor: thisContext) copyStack
			createdObject: returnValue).
	^ returnValue
]

{ #category : #evaluating }
MpMegaAllocationProfilerHandler >> classToRegister [

	^ nil
]

{ #category : #initialization }
MpMegaAllocationProfilerHandler >> initialize [

	super initialize.
	allocations := OrderedCollection new.
	classesToAvoid := self defaultClassesToAvoid
]
