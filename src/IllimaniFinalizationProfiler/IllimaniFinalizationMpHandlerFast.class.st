Class {
	#name : 'IllimaniFinalizationMpHandlerFast',
	#superclass : 'MpHandler',
	#instVars : [
		'profiler',
		'samplingCounter',
		'samplingRate',
		'currentIndex',
		'currentArray',
		'finalizationRegistry',
		'initialArraySize',
		'accumulatedArrays'
	],
	#category : 'IllimaniFinalizationProfiler',
	#package : 'IllimaniFinalizationProfiler'
}

{ #category : 'accessing' }
IllimaniFinalizationMpHandlerFast >> accumulatedArrays [

	^ accumulatedArrays
]

{ #category : 'evaluating' }
IllimaniFinalizationMpHandlerFast >> afterExecutionWithReceiver: receiver arguments: arguments returnValue: newlyAllocatedObject [
	
	"Sampling"
	samplingCounter := samplingCounter + 1.
	samplingCounter % samplingRate = 0 ifFalse: [ ^ newlyAllocatedObject ].
	
	(currentIndex - 1) + 5 > initialArraySize ifTrue: [
		initialArraySize := initialArraySize * 2.
		currentIndex := 1.
		accumulatedArrays add: currentArray.
		currentArray := Array new: initialArraySize ].
	
	currentArray at: currentIndex put: newlyAllocatedObject identityHash.
	currentIndex := currentIndex + 1.
	currentArray at: currentIndex put: Time primUTCMicrosecondsClock.
	currentIndex := currentIndex + 1.
	currentArray at: currentIndex put: newlyAllocatedObject sizeInMemory.
	currentIndex := currentIndex + 1.
	currentArray at: currentIndex put: newlyAllocatedObject class.
	currentIndex := currentIndex + 1.
	"marker"
	currentArray at: currentIndex put: -1.
	currentIndex := currentIndex + 1.

	"Finalization"
	finalizationRegistry add: newlyAllocatedObject finalizer: IllimaniGlobalFinalizer default.
	"profiler addFinalizationFor: newlyAllocatedObject" "finalizer: objectFinalizationModel".
	^ newlyAllocatedObject
]

{ #category : 'accessing' }
IllimaniFinalizationMpHandlerFast >> currentArray [

	^ currentArray
]

{ #category : 'accessing' }
IllimaniFinalizationMpHandlerFast >> currentIndex [

	^ currentIndex
]

{ #category : 'evaluating' }
IllimaniFinalizationMpHandlerFast >> finalize: anObject [

	(currentIndex - 1) + 3 > initialArraySize ifTrue: [
		initialArraySize := initialArraySize * 2.
		currentIndex := 1.
		accumulatedArrays add: currentArray.
		currentArray := Array new: initialArraySize ].

	currentArray at: currentIndex put: anObject identityHash.
	currentIndex := currentIndex + 1.
	currentArray at: currentIndex put: Time primUTCMicrosecondsClock.
	currentIndex := currentIndex + 1.
	"marker"
	currentArray at: currentIndex put: -2.
	currentIndex := currentIndex + 1
]

{ #category : 'accessing' }
IllimaniFinalizationMpHandlerFast >> initialArraySize: anInteger [
	"ONLY USED FOR TESTING"

	initialArraySize := anInteger.
	currentArray := Array new: initialArraySize
]

{ #category : 'initialization' }
IllimaniFinalizationMpHandlerFast >> initialize [

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
IllimaniFinalizationMpHandlerFast >> objectAllocations [

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
IllimaniFinalizationMpHandlerFast >> processForFinalization: allocationsArray model: model atIndex: index [

	model finalizationTimestamp: (allocationsArray at: index - 1)
]

{ #category : 'defaults' }
IllimaniFinalizationMpHandlerFast >> processForInitialization: allocationsArray model: model atIndex: index [

	model
		allocatedObjectClass: (allocationsArray at: index - 1);
		sizeInBytes: (allocationsArray at: index - 2);
		initializationTimestamp: (allocationsArray at: index - 3)
]

{ #category : 'accessing' }
IllimaniFinalizationMpHandlerFast >> profiler [

	^ profiler
]

{ #category : 'accessing' }
IllimaniFinalizationMpHandlerFast >> profiler: anIllimaniFinalizationProfiler [

	profiler := anIllimaniFinalizationProfiler
]

{ #category : 'accessing' }
IllimaniFinalizationMpHandlerFast >> samplingCounter [

	^ samplingCounter
]

{ #category : 'accessing' }
IllimaniFinalizationMpHandlerFast >> samplingCounter: anObject [

	samplingCounter := anObject
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
