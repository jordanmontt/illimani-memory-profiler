Class {
	#name : 'IllMpHandler',
	#superclass : 'MpHandler',
	#instVars : [
		'profiler'
	],
	#category : 'IllimaniKernel',
	#package : 'IllimaniKernel'
}

{ #category : 'evaluating' }
IllMpHandler >> afterExecutionWithReceiver: receiver arguments: arguments returnValue: newlyAllocatedObject [
	
	profiler registerAllocation: newlyAllocatedObject.
	^ newlyAllocatedObject
]

{ #category : 'accessing' }
IllMpHandler >> profiler [

	^ profiler
]

{ #category : 'accessing' }
IllMpHandler >> profiler: anObject [

	profiler := anObject
]
