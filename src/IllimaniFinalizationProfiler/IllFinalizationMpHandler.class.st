Class {
	#name : 'IllFinalizationMpHandler',
	#superclass : 'MpHandler',
	#instVars : [
		'profiler'
	],
	#category : 'IllimaniFinalizationProfiler-Profiler',
	#package : 'IllimaniFinalizationProfiler',
	#tag : 'Profiler'
}

{ #category : 'evaluating' }
IllFinalizationMpHandler >> afterExecutionWithReceiver: receiver arguments: arguments returnValue: newlyAllocatedObject [
	
	profiler registerAllocation: newlyAllocatedObject.
	^ newlyAllocatedObject
]

{ #category : 'accessing' }
IllFinalizationMpHandler >> profiler [

	^ profiler
]

{ #category : 'accessing' }
IllFinalizationMpHandler >> profiler: anObject [

	profiler := anObject
]
