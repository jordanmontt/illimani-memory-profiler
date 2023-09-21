"
I am a class that defines the logic to only registed an specific type of object. I am a subclass of MpHandler, which is required by the method proxy framework. I use the method proxy framework to capture the object allocations.

Please define my `classesToRegister` variable with the classes you want to capture or if you want to capture all use the message `captureAllObjects`
"
Class {
	#name : 'IllAllocationProfilerMpHandler',
	#superclass : 'MpHandler',
	#instVars : [
		'objectAllocations',
		'classesToAvoidInTheContextSearch',
		'captureAllObjects',
		'copyExecutionStack',
		'objectClassesToCapture',
		'samplingCounter',
		'objectClassesToIgnore',
		'samplingRate'
	],
	#category : 'IllimaniAllocationProfiler-Profiler',
	#package : 'IllimaniAllocationProfiler',
	#tag : 'Profiler'
}

{ #category : 'evaluating' }
IllAllocationProfilerMpHandler >> afterExecutionWithReceiver: receiver arguments: arguments returnValue: newlyAllocatedObject [

	"Sampling"
	samplingCounter := samplingCounter + 1.
	samplingCounter % samplingRate = 0 ifFalse: [ ^ newlyAllocatedObject ].
	
	(self shouldICaptureTheObject: newlyAllocatedObject) ifTrue: [
		self handleObjectAllocation: newlyAllocatedObject ].
	^ newlyAllocatedObject
]

{ #category : 'api' }
IllAllocationProfilerMpHandler >> captureAllObjects [
	"When this turned to true I will capture all the allocations of all the objects"

	captureAllObjects := true
]

{ #category : 'api' }
IllAllocationProfilerMpHandler >> copyExecutionStack [
	"When this is set to true, for each object allocationn the full execution stack from which
	the method was created will be copied and store. This information will be available for
	making analysis. Keep in mind that when there is a lot of allocations going the size of
	the image can grow quickly and drastically."

	copyExecutionStack := true
]

{ #category : 'initialization' }
IllAllocationProfilerMpHandler >> defaultClassesToAvoidInTheContextSearch [

	^ {
		  Process.
		  IllAllocationProfilerMpHandler.
		  MpMethodProxy.
		  "BlockClosure."
		  FullBlockClosure
		  "CompiledBlock" }
]

{ #category : 'api' }
IllAllocationProfilerMpHandler >> doNotCaptureAllObjects [
	"See the comment of my opposite method"

	captureAllObjects := false
]

{ #category : 'api' }
IllAllocationProfilerMpHandler >> doNotCopyExecutionStack [
	"See the comment of my opposite method"

	copyExecutionStack := false
]

{ #category : 'evaluating' }
IllAllocationProfilerMpHandler >> filterContext: aContext ignoringClass: aClass [

	| sender |
	sender := aContext sender.
	[
	sender receiver class = aClass or: [
		sender receiver class = aClass class or: [
			classesToAvoidInTheContextSearch includes: sender receiver class ] ] ]
		whileTrue: [ sender := sender sender ].
	^ sender
]

{ #category : 'evaluating' }
IllAllocationProfilerMpHandler >> handleObjectAllocation: newlyAllocatedObject [

	| filteredContext  allocationInformationHolder |

	allocationInformationHolder := AllocationSiteInfoModel new.
	filteredContext := self filterContext: thisContext ignoringClass: newlyAllocatedObject class.

	copyExecutionStack ifTrue: [ allocationInformationHolder context: filteredContext copyStack ].

	allocationInformationHolder
		allocatorClass: filteredContext receiver class;
		allocatorMethod: filteredContext compiledCode method;
		allocatedObjectClass: newlyAllocatedObject class;
		contextFingerprint: filteredContext;
		sizeInBytes: newlyAllocatedObject sizeInMemory;
		initializationTime: Time primUTCMicrosecondsClock.

	objectAllocations add: allocationInformationHolder
]

{ #category : 'initialization' }
IllAllocationProfilerMpHandler >> initialize [

	super initialize.

	copyExecutionStack := false.
	captureAllObjects := false.

	objectClassesToCapture := {  }.
	objectClassesToIgnore := {  }.
	objectAllocations := OrderedCollection new.

	samplingCounter := 0.
	samplingRate := 1.

	"classesToAvoidInContextSearch"
	classesToAvoidInTheContextSearch := self defaultClassesToAvoidInTheContextSearch
	  , (self defaultClassesToAvoidInTheContextSearch collect: [ :aClass | aClass class ])
]

{ #category : 'accessing' }
IllAllocationProfilerMpHandler >> objectAllocations [

	^ objectAllocations
]

{ #category : 'accessing' }
IllAllocationProfilerMpHandler >> objectsToCapture [

	^ objectClassesToCapture
]

{ #category : 'accessing' }
IllAllocationProfilerMpHandler >> objectsToCapture: aCollectionOfClasses [

	objectClassesToCapture := aCollectionOfClasses
]

{ #category : 'accessing' }
IllAllocationProfilerMpHandler >> objectsToIgnore [

	^ objectClassesToIgnore
]

{ #category : 'accessing' }
IllAllocationProfilerMpHandler >> objectsToIgnore: aCollectionOfClasses [

	objectClassesToIgnore := aCollectionOfClasses
]

{ #category : 'accessing' }
IllAllocationProfilerMpHandler >> samplingCounter [

	^ samplingCounter
]

{ #category : 'accessing' }
IllAllocationProfilerMpHandler >> samplingCounter: anInteger [
	"This method is only for testing! As a user, you don't normally will need to use this
	accessor"

	samplingCounter := anInteger
]

{ #category : 'accessing' }
IllAllocationProfilerMpHandler >> samplingRate [
	^ samplingRate
]

{ #category : 'api' }
IllAllocationProfilerMpHandler >> samplingRate: anInteger [
	"The anInteger needs to be an integer number between 1 and 100.  "

	samplingRate := (100 / anInteger) asInteger
]

{ #category : 'testing' }
IllAllocationProfilerMpHandler >> shouldICaptureTheObject: returnValue [

	"Objects to ignore have the priority"
	(objectClassesToIgnore includes: returnValue class) ifTrue: [ ^ false ].
	captureAllObjects ifTrue: [ ^ true ].
	^ objectClassesToCapture includes: returnValue class
]
