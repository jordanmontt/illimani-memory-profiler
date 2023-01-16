Class {
	#name : #MpObjectAllocationProfilerHandler,
	#superclass : #MpHandler,
	#instVars : [
		'allocations',
		'classesToAvoid'
	],
	#category : #AllocationProfiler
}

{ #category : #evaluating }
MpObjectAllocationProfilerHandler >> afterExecutionWithReceiver: receiver arguments: arguments returnValue: returnValue [

	returnValue class = self classToRegister ifTrue: [ 
		allocations add:
			(AllocationInformationHolder
				context: (self contextThatCreatesTheColor: thisContext) copyStack
				createdObject: returnValue) ].
	^ returnValue
]

{ #category : #accessing }
MpObjectAllocationProfilerHandler >> allocations [

	^ allocations
]

{ #category : #evaluating }
MpObjectAllocationProfilerHandler >> classToRegister [

	^ self subclassResponsibility
]

{ #category : #evaluating }
MpObjectAllocationProfilerHandler >> contextThatCreatesTheColor: aContext [

	"(classToAvoid includes: aContext sender methodClass) ifFalse: [ 
	^ aContext sender methodClass ].
	^ self classThatCreatesTheColor: aContext sender"

	| sender |
	sender := aContext sender.
	[ classesToAvoid includes: sender methodClass ] whileTrue: [ 
		sender := sender sender ].
	^ sender
]

{ #category : #initialization }
MpObjectAllocationProfilerHandler >> defaultClassesToAvoid [

	^{ 
		self class.
		MpMethodProxy.
		BlockClosure.
		FullBlockClosure.
		CompiledBlock }
]

{ #category : #initialization }
MpObjectAllocationProfilerHandler >> initialize [

	super initialize.
	allocations := OrderedCollection new.
	classesToAvoid := self defaultClassesToAvoid , { self classToRegister . self classToRegister class }
]

{ #category : #accessing }
MpObjectAllocationProfilerHandler >> statsString [

	^ (ObjectAllocationStatsPresenter on: allocations) asString
]
