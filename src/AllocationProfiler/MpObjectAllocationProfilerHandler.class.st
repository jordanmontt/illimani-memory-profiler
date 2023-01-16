Class {
	#name : #MpObjectAllocationProfilerHandler,
	#superclass : #MpHandler,
	#instVars : [
		'objectAllocations',
		'classesToRegister',
		'classesToAvoidInTheContextSearch'
	],
	#category : #AllocationProfiler
}

{ #category : #evaluating }
MpObjectAllocationProfilerHandler >> afterExecutionWithReceiver: receiver arguments: arguments returnValue: returnValue [

	 (classesToRegister includes: returnValue class) ifTrue: [ 
		objectAllocations add:
			(AllocationInformationHolder
				context: (self contextThatAllocatesTheObject: thisContext) copyStack
				allocatedObject: returnValue) ].
	^ returnValue
]

{ #category : #evaluating }
MpObjectAllocationProfilerHandler >> classesToRegister [

	^ self subclassResponsibility
]

{ #category : #evaluating }
MpObjectAllocationProfilerHandler >> contextThatAllocatesTheObject: aContext [

	"(classToAvoid includes: aContext sender methodClass) ifFalse: [ 
	^ aContext sender methodClass ].
	^ self classThatCreatesTheColor: aContext sender"

	| sender |
	sender := aContext sender.
	[ classesToAvoidInTheContextSearch includes: sender methodClass ] whileTrue: [ 
		sender := sender sender ].
	^ sender
]

{ #category : #initialization }
MpObjectAllocationProfilerHandler >> defaultClassesToAvoidInTheContextSearch [

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
	classesToRegister := self classesToRegister.
	objectAllocations := OrderedCollection new.
	classesToAvoidInTheContextSearch := self defaultClassesToAvoidInTheContextSearch , classesToRegister.
	classesToAvoidInTheContextSearch := classesToAvoidInTheContextSearch , (classesToRegister collect: [ :aClass | aClass class])
]

{ #category : #accessing }
MpObjectAllocationProfilerHandler >> objectAllocations [

	^ objectAllocations
]

{ #category : #accessing }
MpObjectAllocationProfilerHandler >> stats [

	^ ObjectAllocationStats allocations: objectAllocations
]
