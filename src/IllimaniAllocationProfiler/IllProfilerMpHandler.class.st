"
I am a class that defines the logic to only registed an specific type of object. I am a subclass of MpHandler, which is required by the method proxy framework. I use the method proxy framework to capture the object allocations.

Please define my `classesToRegister` variable with the classes you want to capture or if you want to capture all use the message `captureAllObjects`
"
Class {
	#name : 'IllProfilerMpHandler',
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
IllProfilerMpHandler >> afterExecutionWithReceiver: receiver arguments: arguments returnValue: newlyAllocatedObject [

	"Sampling"
	samplingCounter := samplingCounter + 1.
	samplingCounter % samplingRate = 0 ifFalse: [ ^ newlyAllocatedObject ].
	
	(self shouldICaptureTheObject: newlyAllocatedObject) ifTrue: [
		self handleObjectAllocation: newlyAllocatedObject ].
	^ newlyAllocatedObject
]

{ #category : 'api' }
IllProfilerMpHandler >> captureAllObjects [
	"When this turned to true I will capture all the allocations of all the objects"

	captureAllObjects := true
]

{ #category : 'api' }
IllProfilerMpHandler >> cleanObjectAllocations [

	objectAllocations removeAll.
	samplingCounter := 0
]

{ #category : 'api' }
IllProfilerMpHandler >> copyExecutionStack [
	"When this is set to true, for each object allocationn the full execution stack from which
	the method was created will be copied and store. This information will be available for
	making analysis. Keep in mind that when there is a lot of allocations going the size of
	the image can grow quickly and drastically."

	copyExecutionStack := true
]

{ #category : 'initialization' }
IllProfilerMpHandler >> defaultClassesToAvoidInTheContextSearch [

	^ {
		  Process.
		  IllProfilerMpHandler.
		  MpMethodProxy.
		  "BlockClosure."
		  FullBlockClosure
		  "CompiledBlock" }
]

{ #category : 'api' }
IllProfilerMpHandler >> doNotCaptureAllObjects [
	"See the comment of my opposite method"

	captureAllObjects := false
]

{ #category : 'api' }
IllProfilerMpHandler >> doNotCopyExecutionStack [
	"See the comment of my opposite method"

	copyExecutionStack := false
]

{ #category : 'evaluating' }
IllProfilerMpHandler >> filterContext: aContext ignoringClass: aClass [

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
IllProfilerMpHandler >> handleObjectAllocation: newlyAllocatedObject [

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
		initializationTime: Time microsecondClockValue.

	objectAllocations add: allocationInformationHolder
]

{ #category : 'initialization' }
IllProfilerMpHandler >> initialize [

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

{ #category : 'initialization' }
IllProfilerMpHandler >> initializeClassesToAvoidInContextSearch [

	classesToAvoidInTheContextSearch := self defaultClassesToAvoidInTheContextSearch ,
		(self defaultClassesToAvoidInTheContextSearch collect: [ :aClass | aClass class ])
]

{ #category : 'accessing' }
IllProfilerMpHandler >> objectAllocations [

	^ objectAllocations
]

{ #category : 'accessing' }
IllProfilerMpHandler >> objectsToCapture [

	^ objectClassesToCapture
]

{ #category : 'accessing' }
IllProfilerMpHandler >> objectsToCapture: aCollectionOfClasses [

	objectClassesToCapture := aCollectionOfClasses
]

{ #category : 'accessing' }
IllProfilerMpHandler >> objectsToIgnore [

	^ objectClassesToIgnore
]

{ #category : 'accessing' }
IllProfilerMpHandler >> objectsToIgnore: aCollectionOfClasses [

	objectClassesToIgnore := aCollectionOfClasses
]

{ #category : 'accessing' }
IllProfilerMpHandler >> samplingCounter [

	^ samplingCounter
]

{ #category : 'accessing' }
IllProfilerMpHandler >> samplingCounter: anInteger [
	"This method is only for testing! As a user, you don't normally will need to use this
	accessor"

	samplingCounter := anInteger
]

{ #category : 'accessing' }
IllProfilerMpHandler >> samplingRate [
	^ samplingRate
]

{ #category : 'api' }
IllProfilerMpHandler >> samplingRate: anInteger [
	"The anInteger needs to be an integer number between 1 and 100.  "

	samplingRate := (100 / anInteger) asInteger
]

{ #category : 'testing' }
IllProfilerMpHandler >> shouldICaptureTheObject: returnValue [

	"Objects to ignore have the priority"
	(objectClassesToIgnore includes: returnValue class) ifTrue: [ ^ false ].
	captureAllObjects ifTrue: [ ^ true ].
	^ objectClassesToCapture includes: returnValue class
]
