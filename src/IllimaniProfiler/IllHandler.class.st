"
I am a handler that is in charge to delegate the instrumentation actions to the profiler. For more info, read the MethodProxies documentation: [https://github.com/pharo-contributions/MethodProxies](https://github.com/pharo-contributions/MethodProxies)
"
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
