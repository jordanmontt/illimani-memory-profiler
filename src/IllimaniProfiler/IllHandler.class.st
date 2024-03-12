Class {
	#name : 'IllHandler',
	#superclass : 'MpHandler',
	#instVars : [
		'profiler'
	],
	#category : 'IllimaniProfiler-Instrumentation',
	#package : 'IllimaniProfiler',
	#tag : 'Instrumentation'
}

{ #category : 'evaluating' }
IllHandler >> afterExecutionWithReceiver: receiver arguments: arguments returnValue: newlyAllocatedObject [
	
	profiler registerAllocation: newlyAllocatedObject.
	^ newlyAllocatedObject
]

{ #category : 'accessing' }
IllHandler >> profiler [

	^ profiler
]

{ #category : 'accessing' }
IllHandler >> profiler: anObject [

	profiler := anObject
]
