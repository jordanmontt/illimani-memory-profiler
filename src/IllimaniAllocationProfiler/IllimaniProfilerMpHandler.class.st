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
		'keepReferencesToAllocatedObjects',
		'objectClassesToCapture',
		'copyObjectHash',
		'samplingCounter',
		'objectClassesToIgnore',
		'samplingRate'
	],
	#category : #'IllimaniAllocationProfiler-Allocation Sites Profiler'
}

{ #category : #evaluating }
IllimaniProfilerMpHandler >> afterExecutionWithReceiver: receiver arguments: arguments returnValue: newlyAllocatedObject [

	"Sampling"
	samplingCounter := samplingCounter + 1.
	samplingCounter % samplingRate = 0 ifFalse: [ ^ newlyAllocatedObject ].
	
	(self shouldICaptureTheObject: newlyAllocatedObject) ifTrue: [
		self handleObjectAllocation: newlyAllocatedObject ].
	^ newlyAllocatedObject
]

{ #category : #api }
IllimaniProfilerMpHandler >> captureAllObjects [
	"When this turned to true I will capture all the allocations of all the objects"

	captureAllObjects := true.
	"It is necessary to put an empty array when wanting to capture all object allocations"
	self objectsToCapture: {  }
]

{ #category : #api }
IllimaniProfilerMpHandler >> clean [

	objectAllocations removeAll.
	samplingCounter := 0
]

{ #category : #api }
IllimaniProfilerMpHandler >> copyExecutionStack [
	"When this is set to true, for each object allocationn the full execution stack from which
	the method was created will be copied and store. This information will be available for
	making analysis. Keep in mind that when there is a lot of allocations going the size of
	the image can grow quickly and drastically."

	copyExecutionStack := true
]

{ #category : #api }
IllimaniProfilerMpHandler >> copyObjectIdentityHash [
	"When this turned to true I will ask for the hash for all the allocated objects"

	"Keep in mind that if you send the message has to a no configurated object, it will raise
	an exception. So activate this when you are sure that an object is configurated only
	sending the message new."

	copyObjectHash := true
]

{ #category : #initialization }
IllimaniProfilerMpHandler >> defaultClassesToAvoidInTheContextSearch [

	^ {
		  Process.
		  IllimaniProfilerMpHandler.
		  MpMethodProxy.
		  "BlockClosure."
		  FullBlockClosure
		  "CompiledBlock" }
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

{ #category : #evaluating }
IllimaniProfilerMpHandler >> filterContext: aContext ignoringClass: aClass [

	| sender |
	sender := aContext sender.
	[
	sender receiver class = aClass or: [
		sender receiver class = aClass class or: [
			classesToAvoidInTheContextSearch includes: sender receiver class ] ] ]
		whileTrue: [ sender := sender sender ].
	^ sender
]

{ #category : #evaluating }
IllimaniProfilerMpHandler >> handleObjectAllocation: newlyAllocatedObject [

	| filteredContext  allocationInformationHolder |

	allocationInformationHolder := AllocationSiteInfoModel new.
	filteredContext := self filterContext: thisContext ignoringClass: newlyAllocatedObject class.

	copyExecutionStack ifTrue: [ allocationInformationHolder context: filteredContext copyStack ].
	copyObjectHash ifTrue: [ allocationInformationHolder allocatedObjectHash: newlyAllocatedObject hash ].
	keepReferencesToAllocatedObjects ifTrue: [ allocationInformationHolder allocatedObject: newlyAllocatedObject ].

	allocationInformationHolder
		allocatorClass: filteredContext receiver class;
		allocatorMethod: filteredContext compiledCode method;
		allocatedObjectClass: newlyAllocatedObject class;
		contextFingerprint: filteredContext;
		totalSizeInBytes: newlyAllocatedObject sizeInMemory;
		initializationTimestamp: Time microsecondClockValue.

	objectAllocations add: allocationInformationHolder
]

{ #category : #initialization }
IllimaniProfilerMpHandler >> initialize [

	super initialize.
	copyExecutionStack := false.
	captureAllObjects := false.
	copyObjectHash := false.
	keepReferencesToAllocatedObjects := false.
	
	objectClassesToCapture := {  }.
	objectClassesToIgnore := {  }.
	objectAllocations := OrderedCollection new.
	
	samplingCounter := 0.
	samplingRate := 1.
	
	self initializeClassesToAvoidInContextSearch
]

{ #category : #initialization }
IllimaniProfilerMpHandler >> initializeClassesToAvoidInContextSearch [

	classesToAvoidInTheContextSearch := self defaultClassesToAvoidInTheContextSearch ,
		(self defaultClassesToAvoidInTheContextSearch collect: [ :aClass | aClass class ])
]

{ #category : #api }
IllimaniProfilerMpHandler >> keepReferencesToAllocatedObjects [
	"When this turned to true I will copy all the allocated of all the objects"

	"Keep in mind that with option turned on it will affect the GC.
	All the allocated objects will be referenced, because we are keeping them.
	So the GC because it will never discard any of the objects."

	keepReferencesToAllocatedObjects := true
]

{ #category : #accessing }
IllimaniProfilerMpHandler >> objectAllocations [

	^ objectAllocations
]

{ #category : #accessing }
IllimaniProfilerMpHandler >> objectsToCapture: aCollectionOfClasses [

	objectClassesToCapture := aCollectionOfClasses
]

{ #category : #accessing }
IllimaniProfilerMpHandler >> objectsToIgnore: aCollectionOfClasses [

	objectClassesToIgnore := aCollectionOfClasses
]

{ #category : #accessing }
IllimaniProfilerMpHandler >> samplingRate [
	^ samplingRate
]

{ #category : #api }
IllimaniProfilerMpHandler >> samplingRate: anInteger [
	"The anInteger needs to be an integer number between 1 and 100.  "

	samplingRate := (100 / anInteger) asInteger
]

{ #category : #testing }
IllimaniProfilerMpHandler >> shouldICaptureTheObject: returnValue [

	^ (objectClassesToIgnore includes: returnValue class) not and: [
		  captureAllObjects or: [ objectClassesToCapture includes: returnValue class ] ]
]
