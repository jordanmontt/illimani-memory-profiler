"
I am a no-action handler. I am useful to test the *baseline *introduced overhead. That means, to measure the overhead that the profiler (Illimani) introduces, first one can measure the overhead of instrumenting all allocator methods but without taking no action.
"
Class {
	#name : 'IllMpNoActionHandler',
	#superclass : 'MpHandler',
	#instVars : [
		'profiler'
	],
	#category : 'IllimaniProfiler-Instrumentation',
	#package : 'IllimaniProfiler',
	#tag : 'Instrumentation'
}

{ #category : 'evaluating' }
IllMpNoActionHandler >> afterExecutionWithReceiver: receiver arguments: arguments returnValue: newlyAllocatedObject [

	^ newlyAllocatedObject
]

{ #category : 'accessing' }
IllMpNoActionHandler >> profiler [

	^ profiler
]

{ #category : 'accessing' }
IllMpNoActionHandler >> profiler: anObject [

	profiler := anObject
]
