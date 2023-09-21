Class {
	#name : 'IllFinalizationMpHandlerFastOld',
	#superclass : 'MpHandler',
	#instVars : [
		'samplingCounter',
		'samplingRate',
		'currentIndex',
		'finalizationRegistry',
		'initialArraySize',
		'accumulatedArrays',
		'currentArray'
	],
	#category : 'IllimaniFinalizationProfiler',
	#package : 'IllimaniFinalizationProfiler'
}

{ #category : 'accessing' }
IllFinalizationMpHandlerFastOld >> accumulatedArrays [

	^ accumulatedArrays
]

{ #category : 'evaluating' }
IllFinalizationMpHandlerFastOld >> afterExecutionWithReceiver: receiver arguments: arguments returnValue: newlyAllocatedObject [

	| numberOfElementsToAdd |
	numberOfElementsToAdd := 5.
	"Sampling"
	samplingCounter := samplingCounter + 1.
	samplingCounter % samplingRate = 0 ifFalse: [ ^ newlyAllocatedObject ].

	self checkIfArrayIsFull: numberOfElementsToAdd.

	currentArray at: currentIndex put: newlyAllocatedObject identityHash.
	currentArray at: currentIndex + 1 put: Time primUTCMicrosecondsClock.
	currentArray at: currentIndex + 2 put: newlyAllocatedObject sizeInMemory.
	currentArray at: currentIndex + 3 put: newlyAllocatedObject class.
	"marker"
	currentArray at: currentIndex + 4 put: -1.
	currentIndex := currentIndex + numberOfElementsToAdd.

	"Finalization"
	finalizationRegistry add: newlyAllocatedObject finalizer: IllGlobalFinalizer default.
	^ newlyAllocatedObject
]

{ #category : 'evaluating' }
IllFinalizationMpHandlerFastOld >> checkIfArrayIsFull: n [

	currentIndex - 1 + n > initialArraySize ifFalse: [ ^ self ].
	initialArraySize := initialArraySize * 2.
	currentIndex := 1.
	accumulatedArrays add: currentArray.
	currentArray := Array new: initialArraySize
]

{ #category : 'accessing' }
IllFinalizationMpHandlerFastOld >> currentArray [

	^ currentArray
]

{ #category : 'accessing' }
IllFinalizationMpHandlerFastOld >> currentIndex [

	^ currentIndex
]

{ #category : 'evaluating' }
IllFinalizationMpHandlerFastOld >> finalize: anObject [

	| numberOfElementsToAdd |
	numberOfElementsToAdd := 3.
	self checkIfArrayIsFull: numberOfElementsToAdd .

	currentArray at: currentIndex put: anObject identityHash.
	currentArray at: currentIndex + 1 put: Time primUTCMicrosecondsClock.
	"marker"
	currentArray at: currentIndex + 2 put: -2.
	currentIndex := currentIndex + numberOfElementsToAdd
]

{ #category : 'accessing' }
IllFinalizationMpHandlerFastOld >> initialArraySize: anInteger [
	"ONLY USED FOR TESTING"

	initialArraySize := anInteger.
	currentArray := Array new: initialArraySize
]

{ #category : 'initialization' }
IllFinalizationMpHandlerFastOld >> initialize [

	super initialize.
	
	finalizationRegistry := IllFinalizationRegistry new.
	
	accumulatedArrays := OrderedCollection new.
	currentIndex := 1.
	"We want an array big enough to be allocated directly into the old space"
	initialArraySize := 1000000.
	currentArray := Array new: initialArraySize.
	
	IllGlobalFinalizer reset.
	IllGlobalFinalizer default handler: self.
	samplingCounter := 0.
	samplingRate := 1
]

{ #category : 'accessing' }
IllFinalizationMpHandlerFastOld >> objectAllocations [

	| allocationsDictionary |
	allocationsDictionary := Dictionary new.
	accumulatedArrays do: [ :allocationsArray |
		allocationsArray doWithIndex: [ :data :index |
			| model |
			data = -1 ifTrue: [
				model := allocationsDictionary at: (allocationsArray at: index - 4) ifAbsentPut: [ BasicAllocationInfoModel new ].
				self processForInitialization: allocationsArray model: model atIndex: index ].
			data = -2 ifTrue: [
				model := allocationsDictionary at: (allocationsArray at: index - 2).
				self processForFinalization: allocationsArray model: model atIndex: index ] ] ].

	1 to: currentIndex - 1 do: [ :i |
		| model data |
		data := currentArray at: i.
		data = -1 ifTrue: [
			model := allocationsDictionary at: (currentArray at: i - 4) ifAbsentPut: [ BasicAllocationInfoModel new ].
			self processForInitialization: currentArray model: model atIndex: i ].
		data = -2 ifTrue: [
			model := allocationsDictionary at: (currentArray at: i - 2).
			self processForFinalization: currentArray model: model atIndex: i ] ].
	
	^ allocationsDictionary values sorted: [ :a :b | a initializationTimestamp < b initializationTimestamp ]
]

{ #category : 'defaults' }
IllFinalizationMpHandlerFastOld >> processForFinalization: allocationsArray model: model atIndex: index [

	model finalizationTimestamp: (allocationsArray at: index - 1)
]

{ #category : 'defaults' }
IllFinalizationMpHandlerFastOld >> processForInitialization: allocationsArray model: model atIndex: index [

	model
		allocatedObjectClass: (allocationsArray at: index - 1);
		sizeInBytes: (allocationsArray at: index - 2);
		initializationTimestamp: (allocationsArray at: index - 3)
]

{ #category : 'accessing' }
IllFinalizationMpHandlerFastOld >> samplingCounter [

	^ samplingCounter
]

{ #category : 'accessing' }
IllFinalizationMpHandlerFastOld >> samplingCounter: anObject [

	samplingCounter := anObject
]

{ #category : 'accessing' }
IllFinalizationMpHandlerFastOld >> samplingRate [

	^ samplingRate
]

{ #category : 'accessing' }
IllFinalizationMpHandlerFastOld >> samplingRate: anInteger [
	"The anInteger needs to be an integer number between 1 and 100 that represents the sampling percentage"

	samplingRate := (100 / anInteger) asInteger
]
