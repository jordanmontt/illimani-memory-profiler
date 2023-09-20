Class {
	#name : 'IllimaniFinalizationMpHandler',
	#superclass : 'MpHandler',
	#instVars : [
		'profiler',
		'samplingCounter',
		'samplingRate',
		'objectAllocations'
	],
	#category : 'IllimaniFinalizationProfiler',
	#package : 'IllimaniFinalizationProfiler'
}

{ #category : 'evaluating' }
IllimaniFinalizationMpHandler >> afterExecutionWithReceiver: receiver arguments: arguments returnValue: newlyAllocatedObject [
	
	| objectFinalizationModel |
	
	"Sampling"
	samplingCounter := samplingCounter + 1.
	samplingCounter % samplingRate = 0 ifFalse: [ ^ newlyAllocatedObject ].
	
	"Handle object allocation"
	objectFinalizationModel := BasicAllocationInfoModel new
		initializationTimestamp: Time microsecondClockValue;
		totalSizeInBytes: newlyAllocatedObject sizeInMemory;
		allocatedObjectClass: newlyAllocatedObject class;
		yourself.

	objectAllocations add: objectFinalizationModel.

	"Finalization"
	profiler addFinalizationFor: newlyAllocatedObject finalizer: objectFinalizationModel.
	^ newlyAllocatedObject
]

{ #category : 'evaluating' }
IllimaniFinalizationMpHandler >> cleanObjectAllocations [

	objectAllocations removeAll.
	samplingCounter := 0
]

{ #category : 'initialization' }
IllimaniFinalizationMpHandler >> initialize [

	super initialize.

	objectAllocations := OrderedCollection new.
	samplingCounter := 0.
	samplingRate := 1
]

{ #category : 'accessing' }
IllimaniFinalizationMpHandler >> objectAllocations [

	^ objectAllocations
]

{ #category : 'accessing' }
IllimaniFinalizationMpHandler >> objectAllocations: anObject [

	objectAllocations := anObject
]

{ #category : 'accessing' }
IllimaniFinalizationMpHandler >> profiler [

	^ profiler
]

{ #category : 'accessing' }
IllimaniFinalizationMpHandler >> profiler: anIllimaniFinalizationProfiler [

	profiler := anIllimaniFinalizationProfiler
]

{ #category : 'accessing' }
IllimaniFinalizationMpHandler >> samplingCounter [

	^ samplingCounter
]

{ #category : 'accessing' }
IllimaniFinalizationMpHandler >> samplingCounter: anObject [

	samplingCounter := anObject
]

{ #category : 'accessing' }
IllimaniFinalizationMpHandler >> samplingRate [

	^ samplingRate
]

{ #category : 'accessing' }
IllimaniFinalizationMpHandler >> samplingRate: anInteger [
	"The anInteger needs to be an integer number between 1 and 100 that represents the sampling percentage"

	samplingRate := (100 / anInteger) asInteger
]
