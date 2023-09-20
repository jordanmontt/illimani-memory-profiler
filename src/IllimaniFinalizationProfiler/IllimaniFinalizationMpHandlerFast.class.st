Class {
	#name : 'IllimaniFinalizationMpHandlerFast',
	#superclass : 'MpHandler',
	#instVars : [
		'samplingCounter',
		'samplingRate',
		'finalizationRegistry',
		'initialArraySize',
		'allocationsUnconstructedCollection'
	],
	#category : 'IllimaniFinalizationProfiler',
	#package : 'IllimaniFinalizationProfiler'
}

{ #category : 'evaluating' }
IllimaniFinalizationMpHandlerFast >> afterExecutionWithReceiver: receiver arguments: arguments returnValue: newlyAllocatedObject [

	"Sampling"
	samplingCounter := samplingCounter + 1.
	samplingCounter % samplingRate = 0 ifFalse: [ ^ newlyAllocatedObject ].

	allocationsUnconstructedCollection add: newlyAllocatedObject identityHash.
	allocationsUnconstructedCollection add: Time primUTCMicrosecondsClock.
	allocationsUnconstructedCollection add: newlyAllocatedObject sizeInMemory.
	allocationsUnconstructedCollection add: newlyAllocatedObject class.
	"marker"
	allocationsUnconstructedCollection add: -1.

	"Finalization"
	finalizationRegistry add: newlyAllocatedObject finalizer: IllimaniGlobalFinalizer default.
	^ newlyAllocatedObject
]

{ #category : 'accessing' }
IllimaniFinalizationMpHandlerFast >> allocationsUnconstructedCollection [

	^ allocationsUnconstructedCollection
]

{ #category : 'evaluating' }
IllimaniFinalizationMpHandlerFast >> finalize: anObject [

	allocationsUnconstructedCollection add: anObject identityHash.
	allocationsUnconstructedCollection add: Time primUTCMicrosecondsClock.
	"marker"
	allocationsUnconstructedCollection add: -2
]

{ #category : 'initialization' }
IllimaniFinalizationMpHandlerFast >> initialize [

	super initialize.
	
	finalizationRegistry := IllimaniFinalizationRegistry new.
	
	"We want an array big enough to be allocated directly into the old space"
	initialArraySize := 10000000.
	allocationsUnconstructedCollection := OrderedCollection new: initialArraySize.
	
	IllimaniGlobalFinalizer reset.
	IllimaniGlobalFinalizer default handler: self.
	samplingCounter := 0.
	samplingRate := 1
]

{ #category : 'accessing' }
IllimaniFinalizationMpHandlerFast >> objectAllocations [

	| allocationsDictionary |
	allocationsDictionary := Dictionary new.
	allocationsUnconstructedCollection doWithIndex: [ :data :index |
		| model |
		data = -1 ifTrue: [
			model := allocationsDictionary at: (allocationsUnconstructedCollection at: index - 4) ifAbsentPut: [ BasicAllocationInfoModel new ].
			self processInitialization: model atIndex: index ].
		data = -2 ifTrue: [
			model := allocationsDictionary at: (allocationsUnconstructedCollection at: index - 2).
			self processFinalization: model atIndex: index ] ].

	^ allocationsDictionary values sorted: [ :a :b | a initializationTimestamp < b initializationTimestamp ]
]

{ #category : 'defaults' }
IllimaniFinalizationMpHandlerFast >> processFinalization: model atIndex: index [

	model finalizationTimestamp: (allocationsUnconstructedCollection at: index - 1)
]

{ #category : 'defaults' }
IllimaniFinalizationMpHandlerFast >> processInitialization: model atIndex: index [

	model
		allocatedObjectClass: (allocationsUnconstructedCollection at: index - 1);
		sizeInBytes: (allocationsUnconstructedCollection at: index - 2);
		initializationTimestamp: (allocationsUnconstructedCollection at: index - 3)
]

{ #category : 'accessing' }
IllimaniFinalizationMpHandlerFast >> samplingCounter [

	^ samplingCounter
]

{ #category : 'accessing' }
IllimaniFinalizationMpHandlerFast >> samplingRate [

	^ samplingRate
]

{ #category : 'accessing' }
IllimaniFinalizationMpHandlerFast >> samplingRate: anInteger [
	"The anInteger needs to be an integer number between 1 and 100 that represents the sampling percentage"

	samplingRate := (100 / anInteger) asInteger
]
