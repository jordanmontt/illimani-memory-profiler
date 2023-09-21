Class {
	#name : 'IllFinalizationMpHandler',
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
IllFinalizationMpHandler >> afterExecutionWithReceiver: receiver arguments: arguments returnValue: newlyAllocatedObject [
	
	| objectFinalizationModel |
	
	"Sampling"
	samplingCounter := samplingCounter + 1.
	samplingCounter % samplingRate = 0 ifFalse: [ ^ newlyAllocatedObject ].
	
	"Handle object allocation"
	objectFinalizationModel := BasicAllocationInfoModel new
		initializationTimestamp: Time microsecondClockValue;
		sizeInBytes: newlyAllocatedObject sizeInMemory;
		allocatedObjectClass: newlyAllocatedObject class;
		yourself.

	objectAllocations add: objectFinalizationModel.

	"Finalization"
	profiler addFinalizationFor: newlyAllocatedObject finalizer: objectFinalizationModel.
	^ newlyAllocatedObject
]

{ #category : 'initialization' }
IllFinalizationMpHandler >> initialize [

	super initialize.

	objectAllocations := OrderedCollection new.
	samplingCounter := 0.
	samplingRate := 1
]

{ #category : 'accessing' }
IllFinalizationMpHandler >> objectAllocations [

	^ objectAllocations
]

{ #category : 'accessing' }
IllFinalizationMpHandler >> objectAllocations: anObject [

	objectAllocations := anObject
]

{ #category : 'accessing' }
IllFinalizationMpHandler >> profiler [

	^ profiler
]

{ #category : 'accessing' }
IllFinalizationMpHandler >> profiler: anIllimaniFinalizationProfiler [

	profiler := anIllimaniFinalizationProfiler
]

{ #category : 'accessing' }
IllFinalizationMpHandler >> samplingCounter [

	^ samplingCounter
]

{ #category : 'accessing' }
IllFinalizationMpHandler >> samplingCounter: anObject [

	samplingCounter := anObject
]

{ #category : 'accessing' }
IllFinalizationMpHandler >> samplingRate [

	^ samplingRate
]

{ #category : 'accessing' }
IllFinalizationMpHandler >> samplingRate: anInteger [
	"The anInteger needs to be an integer number between 1 and 100 that represents the sampling percentage"

	samplingRate := (100 / anInteger) asInteger
]
