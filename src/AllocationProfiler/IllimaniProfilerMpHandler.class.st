"
I am a class that defines the logic to only registed an specific type of object. I am a subclass of MpHandler, which is required by the method proxy framework. I use the method proxy framework to capture the object allocations.

Please define my `classesToRegister` variable with the classes you want to capture or if you want to capture all use the message `captureAllObjects`
"
Class {
	#name : #IllimaniProfilerMpHandler,
	#superclass : #MpHandler,
	#instVars : [
		'objectAllocations',
		'classesToAvoidInTheContextSearch',
		'captureAllObjects',
		'copyExecutionStack',
		'classesToCapture'
	],
	#category : #AllocationProfiler
}

{ #category : #evaluating }
IllimaniProfilerMpHandler >> afterExecutionWithReceiver: receiver arguments: arguments returnValue: returnValue [

	captureAllObjects
		ifTrue: [ objectAllocations add: (self allocationHolderForObject: returnValue) ]
		ifFalse: [ (self shouldICaptureTheObject: returnValue)
			ifTrue: [ objectAllocations add: (self allocationHolderForObject: returnValue) ] ].
	^ returnValue
]

{ #category : #evaluating }
IllimaniProfilerMpHandler >> allocationHolderForObject: returnValue [

	| context timeNow allocationInformationHolder |
	timeNow := DateAndTime now.
	allocationInformationHolder := AllocationInformationHolder new.
	context := self contextThatAllocatedTheObject: thisContext.
	copyExecutionStack ifTrue: [ allocationInformationHolder context: context copyStack ].

	allocationInformationHolder
		allocatorClass: context methodClass;
		allocatorMethodName: context compiledCode method name;
		allocatedObject: returnValue;
		timestamp: timeNow.
	^ allocationInformationHolder
]

{ #category : #api }
IllimaniProfilerMpHandler >> captureAllObjects [
	"When this turned to true I will capture all the allocations of all the objects"

	captureAllObjects := true.
	"It is necessary to put an empty array when wanting to capture all object allocations"
	self classesToCapture: {  }
]

{ #category : #accessing }
IllimaniProfilerMpHandler >> classesToCapture [

	^ classesToCapture
]

{ #category : #accessing }
IllimaniProfilerMpHandler >> classesToCapture: aCollection [

	classesToCapture := aCollection.
	self initializeClassesToAvoidInContextSearch
]

{ #category : #api }
IllimaniProfilerMpHandler >> cleanAllocations [

	objectAllocations removeAll
]

{ #category : #evaluating }
IllimaniProfilerMpHandler >> contextThatAllocatedTheObject: aContext [

	| sender |
	sender := aContext sender.
	[ classesToAvoidInTheContextSearch includes: sender methodClass ] whileTrue: [
		sender := sender sender ].
	^ sender
]

{ #category : #api }
IllimaniProfilerMpHandler >> copyExecutionStack [
	"When this is set to true, for each object allocationn the full execution stack from which
	the method was created will be copied and store. This information will be available for
	making analysis. Keep in mind that when there is a lot of allocations going the size of
	the image can grow quickly and drastically."

	copyExecutionStack := true
]

{ #category : #initialization }
IllimaniProfilerMpHandler >> defaultClassesToAvoidInTheContextSearch [

	^{
		IllimaniProfilerMpHandler.
		self class.
		MpMethodProxy.
		BlockClosure.
		FullBlockClosure.
		CompiledBlock }
]

{ #category : #api }
IllimaniProfilerMpHandler >> doNotCaptureAllObjects [
	"See the comment of my opposite method"

	captureAllObjects := false
]

{ #category : #api }
IllimaniProfilerMpHandler >> doNotCopyExecutionStack [
	"See the comment of my opposite method"

	copyExecutionStack := false
]

{ #category : #initialization }
IllimaniProfilerMpHandler >> initialize [

	super initialize.
	self doNotCopyExecutionStack.
	self doNotCaptureAllObjects.
	classesToCapture := { }.
	objectAllocations := OrderedCollection new.
	self initializeClassesToAvoidInContextSearch
]

{ #category : #initialization }
IllimaniProfilerMpHandler >> initializeClassesToAvoidInContextSearch [

	classesToAvoidInTheContextSearch := self defaultClassesToAvoidInTheContextSearch , classesToCapture.
	classesToAvoidInTheContextSearch := classesToAvoidInTheContextSearch ,
		(classesToCapture collect: [ :aClass | aClass class ])
]

{ #category : #accessing }
IllimaniProfilerMpHandler >> objectAllocations [

	^ objectAllocations
]

{ #category : #testing }
IllimaniProfilerMpHandler >> shouldICaptureTheObject: returnValue [

	^ classesToCapture includes: returnValue class
]
