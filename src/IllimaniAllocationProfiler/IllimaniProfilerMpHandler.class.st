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
		'graphWalker',
		'keepReferencesToAllocatedObjects',
		'allocatorClassesToIgnore',
		'objectClassesToCapture',
		'copyObjectHash',
		'illimaniFinalizationRegistry'
	],
	#category : #'IllimaniAllocationProfiler-Profiler'
}

{ #category : #evaluating }
IllimaniProfilerMpHandler >> afterExecutionWithReceiver: receiver arguments: arguments returnValue: returnValue [

	(self shouldICaptureTheObject: returnValue) ifTrue: [
		self handleAllocationOfObject: returnValue ].
	^ returnValue
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

	self cleanAllocations.
	illimaniFinalizationRegistry := FinalizationRegistry new.
]

{ #category : #api }
IllimaniProfilerMpHandler >> cleanAllocations [

	objectAllocations removeAll
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
		IllimaniProfilerMpHandler.
		MpMethodProxy.
		"BlockClosure."
		FullBlockClosure.
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
IllimaniProfilerMpHandler >> handleAllocationOfObject: newlyAllocatedObject [

	| filteredContext timeNow allocationInformationHolder |
		
	timeNow := Time microsecondClockValue.
	allocationInformationHolder := AllocationInfoDTO new.
	filteredContext := self filterContext: thisContext ignoringClass: newlyAllocatedObject class.

	"Finalization"
	illimaniFinalizationRegistry
		add: newlyAllocatedObject
		finalizer: (IllimaniFinalizer new model: allocationInformationHolder).

	copyExecutionStack ifTrue: [ allocationInformationHolder context: filteredContext copyStack ].
	copyObjectHash ifTrue: [ allocationInformationHolder allocatedObjectHash: newlyAllocatedObject hash ].
	keepReferencesToAllocatedObjects ifTrue: [ allocationInformationHolder allocatedObject: newlyAllocatedObject ].

	allocationInformationHolder
		allocatorClass: filteredContext receiver class;
		allocatorMethod: filteredContext compiledCode method;
		allocatedObjectClass: newlyAllocatedObject class;
		contextFingerprint: filteredContext;
		totalSizeInBytes: (graphWalker rootObject: newlyAllocatedObject) totalSizeInBytes;
		timestamp: timeNow.

	objectAllocations add: allocationInformationHolder
]

{ #category : #accessing }
IllimaniProfilerMpHandler >> ignoreAllocators: aCollectionOfClasses [

	allocatorClassesToIgnore := aCollectionOfClasses
]

{ #category : #initialization }
IllimaniProfilerMpHandler >> initialize [

	super initialize.
	self doNotCopyExecutionStack.
	self doNotCaptureAllObjects.
	copyObjectHash := false.
	keepReferencesToAllocatedObjects := false.
	objectClassesToCapture := {  }.
	allocatorClassesToIgnore := {  }.
	objectAllocations := OrderedCollection new.
	graphWalker := GraphSpaceStatistics new.
	illimaniFinalizationRegistry := FinalizationRegistry new.
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
IllimaniProfilerMpHandler >> objectsToCapture [

	^ objectClassesToCapture
]

{ #category : #accessing }
IllimaniProfilerMpHandler >> objectsToCapture: aCollectionOfClasses [

	objectClassesToCapture := aCollectionOfClasses
]

{ #category : #testing }
IllimaniProfilerMpHandler >> shouldICaptureTheObject: returnValue [

	^ (captureAllObjects or: [ objectClassesToCapture includes: returnValue class ]) and: [
		  (allocatorClassesToIgnore includes: returnValue class) not ]
]
