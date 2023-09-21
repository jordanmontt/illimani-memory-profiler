Class {
	#name : 'IllFinalizationMpHandlerFast',
	#superclass : 'MpHandler',
	#instVars : [
		'profiler'
	],
	#category : 'IllimaniFinalizationProfiler-MethodProxies-Handler',
	#package : 'IllimaniFinalizationProfiler',
	#tag : 'MethodProxies-Handler'
}

{ #category : 'evaluating' }
IllFinalizationMpHandlerFast >> afterExecutionWithReceiver: receiver arguments: arguments returnValue: newlyAllocatedObject [

	profiler registerAllocation: newlyAllocatedObject.
	^ newlyAllocatedObject
]

{ #category : 'accessing' }
IllFinalizationMpHandlerFast >> profiler [

	^ profiler
]

{ #category : 'accessing' }
IllFinalizationMpHandlerFast >> profiler: anObject [

	profiler := anObject
]
