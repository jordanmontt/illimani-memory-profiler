Class {
	#name : 'IllFinalizationMpHandler',
	#superclass : 'MpHandler',
	#instVars : [
		'profiler',
		'samplingCounter',
		'samplingRate'
	],
	#category : 'IllimaniFinalizationProfiler-Profiler',
	#package : 'IllimaniFinalizationProfiler',
	#tag : 'Profiler'
}

{ #category : 'evaluating' }
IllFinalizationMpHandler >> afterExecutionWithReceiver: receiver arguments: arguments returnValue: newlyAllocatedObject [

	"Sampling"
	"samplingCounter := samplingCounter + 1.
	samplingCounter % samplingRate = 0 ifFalse: [ ^ newlyAllocatedObject ]."
	
	profiler registerAllocation: newlyAllocatedObject.
	^ newlyAllocatedObject
]

{ #category : 'initialization' }
IllFinalizationMpHandler >> initialize [

	super initialize.
	samplingCounter := 0.
	samplingRate := 1
]

{ #category : 'accessing' }
IllFinalizationMpHandler >> profiler [

	^ profiler
]

{ #category : 'accessing' }
IllFinalizationMpHandler >> profiler: anObject [

	profiler := anObject
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
