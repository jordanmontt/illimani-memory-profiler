"
I am the handler of the instrumentation. It is me who will be implementing the methods that will be executed before and after the proxified method's execution.

In the after method, afther the object has been allocated, I delegate the action to the profiler.
"
Class {
	#name : 'IllHandler',
	#superclass : 'MpHandler',
	#instVars : [
		'profiler'
	],
	#category : 'Illimani-FrameworkProfiler-Instrumentation',
	#package : 'Illimani-FrameworkProfiler',
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
