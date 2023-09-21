Class {
	#name : 'IllFinalizationMpHandlerUnconstructedCollection',
	#superclass : 'MpHandler',
	#instVars : [
		'samplingCounter',
		'samplingRate',
		'finalizationRegistry',
		'initialArraySize',
		'allocationsUnconstructedCollection'
	],
	#category : 'IllimaniFinalizationProfiler-MethodProxies-Handler',
	#package : 'IllimaniFinalizationProfiler',
	#tag : 'MethodProxies-Handler'
}

{ #category : 'evaluating' }
IllFinalizationMpHandlerUnconstructedCollection >> afterExecutionWithReceiver: receiver arguments: arguments returnValue: newlyAllocatedObject [

	"Sampling"
	"samplingCounter := samplingCounter + 1.
	samplingCounter % samplingRate = 0 ifFalse: [ ^ newlyAllocatedObject ]."

	allocationsUnconstructedCollection add: newlyAllocatedObject identityHash.
	allocationsUnconstructedCollection add: Time primUTCMicrosecondsClock.
	allocationsUnconstructedCollection add: newlyAllocatedObject sizeInMemory.
	allocationsUnconstructedCollection add: newlyAllocatedObject class.
	"marker"
	allocationsUnconstructedCollection add: -1.

	"Finalization"
	finalizationRegistry add: newlyAllocatedObject finalizer: self.
	^ newlyAllocatedObject
]

{ #category : 'accessing' }
IllFinalizationMpHandlerUnconstructedCollection >> allocationsUnconstructedCollection [

	^ allocationsUnconstructedCollection
]

{ #category : 'evaluating' }
IllFinalizationMpHandlerUnconstructedCollection >> finalize: anObject [

	allocationsUnconstructedCollection add: anObject identityHash.
	allocationsUnconstructedCollection add: Time primUTCMicrosecondsClock.
	"marker"
	allocationsUnconstructedCollection add: -2
]

{ #category : 'evaluating' }
IllFinalizationMpHandlerUnconstructedCollection >> forceFinalizationOfObjects [

	"We force the finalization timestamp for the not yet finalized objects."
	finalizationRegistry finalizeAllEphemerons.
	"Then we stop referencing the finalization registry to not re-finalize the objects."
	finalizationRegistry := IllFinalizationRegistry new
]

{ #category : 'initialization' }
IllFinalizationMpHandlerUnconstructedCollection >> initialize [

	super initialize.

	finalizationRegistry := IllFinalizationRegistry new.
	samplingCounter := 0.
	samplingRate := 1.

	"We want an array big enough to be allocated directly into the old space"
	initialArraySize := 10000000.
	allocationsUnconstructedCollection := OrderedCollection new: initialArraySize
]

{ #category : 'accessing' }
IllFinalizationMpHandlerUnconstructedCollection >> objectAllocations [

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

	^ allocationsDictionary values sorted: [ :a :b | a initializationTime < b initializationTime ]
]

{ #category : 'defaults' }
IllFinalizationMpHandlerUnconstructedCollection >> processFinalization: model atIndex: index [

	model finalizationTime: (allocationsUnconstructedCollection at: index - 1)
]

{ #category : 'defaults' }
IllFinalizationMpHandlerUnconstructedCollection >> processInitialization: model atIndex: index [

	model
		allocatedObjectClass: (allocationsUnconstructedCollection at: index - 1);
		sizeInBytes: (allocationsUnconstructedCollection at: index - 2);
		initializationTime: (allocationsUnconstructedCollection at: index - 3)
]

{ #category : 'accessing' }
IllFinalizationMpHandlerUnconstructedCollection >> samplingCounter [

	^ samplingCounter
]

{ #category : 'accessing' }
IllFinalizationMpHandlerUnconstructedCollection >> samplingRate [

	^ samplingRate
]

{ #category : 'accessing' }
IllFinalizationMpHandlerUnconstructedCollection >> samplingRate: anInteger [
	"The anInteger needs to be an integer number between 1 and 100 that represents the sampling percentage"

	samplingRate := (100 / anInteger) asInteger
]
