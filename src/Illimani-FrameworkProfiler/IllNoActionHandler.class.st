"
I am a no-action handler. I am useful to test the *baseline *introduced overhead. That means, to measure the overhead that the profiler (Illimani) introduces, first one can measure the overhead of instrumenting all allocator methods but without taking no action.
"
Class {
	#name : 'IllNoActionHandler',
	#superclass : 'MpHandler',
	#instVars : [
		'profiler'
	],
	#category : 'Illimani-FrameworkProfiler-Instrumentation',
	#package : 'Illimani-FrameworkProfiler',
	#tag : 'Instrumentation'
}

{ #category : 'evaluating' }
IllNoActionHandler >> afterExecutionWithReceiver: receiver arguments: arguments returnValue: newlyAllocatedObject [

	^ newlyAllocatedObject
]

{ #category : 'accessing' }
IllNoActionHandler >> profiler [

	^ profiler
]

{ #category : 'accessing' }
IllNoActionHandler >> profiler: anObject [

	profiler := anObject
]
