Class {
	#name : 'IllFinalizationMpHandlerUnconstructedCollection',
	#superclass : 'MpHandler',
	#instVars : [
		'samplingCounter',
		'samplingRate',
		'profiler'
	],
	#category : 'IllimaniFinalizationProfiler-Speedup-Experimental',
	#package : 'IllimaniFinalizationProfiler',
	#tag : 'Speedup-Experimental'
}

{ #category : 'evaluating' }
IllFinalizationMpHandlerUnconstructedCollection >> afterExecutionWithReceiver: receiver arguments: arguments returnValue: newlyAllocatedObject [

	"Sampling"
	"samplingCounter := samplingCounter + 1.
	samplingCounter % samplingRate = 0 ifFalse: [ ^ newlyAllocatedObject ]."

	profiler registerAllocation: newlyAllocatedObject.
	^ newlyAllocatedObject
]

{ #category : 'initialization' }
IllFinalizationMpHandlerUnconstructedCollection >> initialize [

	super initialize.
	samplingCounter := 0.
	samplingRate := 1
]

{ #category : 'initialization' }
IllFinalizationMpHandlerUnconstructedCollection >> profiler: aProfiler [

	profiler := aProfiler
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
