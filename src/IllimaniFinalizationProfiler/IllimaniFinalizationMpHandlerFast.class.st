Class {
	#name : 'IllimaniFinalizationMpHandlerFast',
	#superclass : 'MpHandler',
	#instVars : [
		'profiler',
		'samplingCounter',
		'samplingRate',
		'currentIndex',
		'arrMaxSize',
		'arrays',
		'currentArray',
		'finalizationRegistry'
	],
	#category : 'IllimaniFinalizationProfiler',
	#package : 'IllimaniFinalizationProfiler'
}

{ #category : 'evaluating' }
IllimaniFinalizationMpHandlerFast >> afterExecutionWithReceiver: receiver arguments: arguments returnValue: newlyAllocatedObject [
	
	"Sampling"
	samplingCounter := samplingCounter + 1.
	samplingCounter % samplingRate = 0 ifFalse: [ ^ newlyAllocatedObject ].
	
	currentIndex + 5 > arrMaxSize ifTrue: [
		arrMaxSize := arrMaxSize * 2.
		currentIndex := 1.
		arrays add: currentArray.
		currentArray := Array new: arrMaxSize ].
	
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
	profiler addFinalizationFor: newlyAllocatedObject "finalizer: objectFinalizationModel".
	^ newlyAllocatedObject
]

{ #category : 'evaluating' }
IllimaniFinalizationMpHandlerFast >> finalize: anObject [

	currentIndex + 3 > arrMaxSize ifTrue: [
		arrMaxSize := arrMaxSize * 2.
		currentIndex := 1.
		arrays add: currentArray.
		currentArray := Array new: arrMaxSize ].

	currentArray at: currentIndex put: anObject identityHash.
	currentIndex := currentIndex + 1.
	currentArray at: currentIndex put: Time primUTCMicrosecondsClock.
	currentIndex := currentIndex + 1.
	"marker"
	currentArray at: currentIndex put: -2.
	currentIndex := currentIndex + 1
]

{ #category : 'initialization' }
IllimaniFinalizationMpHandlerFast >> initialize [

	super initialize.
	
	arrays := OrderedCollection new.
	currentIndex := 1.
	"We want an array big enough to be allocated directly into the old space"
	arrMaxSize := 1000000.
	currentArray := Array new: arrMaxSize.
	
	IllimaniGlobalFinalizer reset.
	IllimaniGlobalFinalizer default handler: self.
	samplingCounter := 0.
	samplingRate := 1
]

{ #category : 'accessing' }
IllimaniFinalizationMpHandlerFast >> objectAllocations [

	^ {  }
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
