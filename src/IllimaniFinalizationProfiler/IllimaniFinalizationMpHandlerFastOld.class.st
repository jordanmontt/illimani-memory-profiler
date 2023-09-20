Class {
	#name : 'IllimaniFinalizationMpHandlerFastOld',
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
IllimaniFinalizationMpHandlerFastOld >> accumulatedArrays [

	^ accumulatedArrays
]

{ #category : 'evaluating' }
IllimaniFinalizationMpHandlerFastOld >> afterExecutionWithReceiver: receiver arguments: arguments returnValue: newlyAllocatedObject [

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
	finalizationRegistry add: newlyAllocatedObject finalizer: IllimaniGlobalFinalizer default.
	^ newlyAllocatedObject
]

{ #category : 'evaluating' }
IllimaniFinalizationMpHandlerFastOld >> checkIfArrayIsFull: n [

	currentIndex - 1 + n > initialArraySize ifFalse: [ ^ self ].
	initialArraySize := initialArraySize * 2.
	currentIndex := 1.
	accumulatedArrays add: currentArray.
	currentArray := Array new: initialArraySize
]

{ #category : 'accessing' }
IllimaniFinalizationMpHandlerFastOld >> currentArray [

	^ currentArray
]

{ #category : 'accessing' }
IllimaniFinalizationMpHandlerFastOld >> currentIndex [

	^ currentIndex
]

{ #category : 'evaluating' }
IllimaniFinalizationMpHandlerFastOld >> finalize: anObject [

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
IllimaniFinalizationMpHandlerFastOld >> initialArraySize: anInteger [
	"ONLY USED FOR TESTING"

	initialArraySize := anInteger.
	currentArray := Array new: initialArraySize
]

{ #category : 'initialization' }
IllimaniFinalizationMpHandlerFastOld >> initialize [

	super initialize.
	
	finalizationRegistry := IllimaniFinalizationRegistry new.
	
	accumulatedArrays := OrderedCollection new.
	currentIndex := 1.
	"We want an array big enough to be allocated directly into the old space"
	initialArraySize := 1000000.
	currentArray := Array new: initialArraySize.
	
	IllimaniGlobalFinalizer reset.
	IllimaniGlobalFinalizer default handler: self.
	samplingCounter := 0.
	samplingRate := 1
]

{ #category : 'accessing' }
IllimaniFinalizationMpHandlerFastOld >> objectAllocations [

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
IllimaniFinalizationMpHandlerFastOld >> processForFinalization: allocationsArray model: model atIndex: index [

	model finalizationTimestamp: (allocationsArray at: index - 1)
]

{ #category : 'defaults' }
IllimaniFinalizationMpHandlerFastOld >> processForInitialization: allocationsArray model: model atIndex: index [

	model
		allocatedObjectClass: (allocationsArray at: index - 1);
		sizeInBytes: (allocationsArray at: index - 2);
		initializationTimestamp: (allocationsArray at: index - 3)
]

{ #category : 'accessing' }
IllimaniFinalizationMpHandlerFastOld >> samplingCounter [

	^ samplingCounter
]

{ #category : 'accessing' }
IllimaniFinalizationMpHandlerFastOld >> samplingCounter: anObject [

	samplingCounter := anObject
]

{ #category : 'accessing' }
IllimaniFinalizationMpHandlerFastOld >> samplingRate [

	^ samplingRate
]

{ #category : 'accessing' }
IllimaniFinalizationMpHandlerFastOld >> samplingRate: anInteger [
	"The anInteger needs to be an integer number between 1 and 100 that represents the sampling percentage"

	samplingRate := (100 / anInteger) asInteger
]
