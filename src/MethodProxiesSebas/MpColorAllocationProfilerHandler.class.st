"
I am a handler that register when a color is created. I keep that of both the color and the creation context
"
Class {
	#name : #MpColorAllocationProfilerHandler,
	#superclass : #MpHandler,
	#instVars : [
		'allocations',
		'classesToAvoid'
	],
	#category : #MethodProxiesSebas
}

{ #category : #evaluating }
MpColorAllocationProfilerHandler >> afterExecutionWithReceiver: receiver arguments: arguments returnValue: returnValue [

	returnValue class = Color ifTrue: [
		allocations add: (self contextThatCreatesTheColor: thisContext) -> returnValue ].
	^ returnValue
]

{ #category : #evaluating }
MpColorAllocationProfilerHandler >> contextThatCreatesTheColor: aContext [

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
MpColorAllocationProfilerHandler >> initialize [

	super initialize.
	allocations := OrderedCollection new.
	classesToAvoid := { 
		Color class.
		Color.
		MpColorAllocationProfilerHandler.
		MpMethodProxy.
		BlockClosure.
		FullBlockClosure.
		CompiledBlock }
]
