"
I am a class that defines the logic to only registed an specific type of object. I am a subclass of MpHandler, which is required by the method proxy framework. I use the method proxy framework to capture the object allocations.

You need to subclass me and define the method `classesToRegister` with a list of classes. Each time that a method is allocated, I will be called and if the object class is in the list of `classesToRegister` I will register the allocation.
"
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
