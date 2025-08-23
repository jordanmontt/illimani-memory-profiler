Class {
	#name : 'AllocationGraphSample',
	#superclass : 'Object',
	#instVars : [
		'sendersCallStack'
	],
	#category : 'AllocationCallGraph-Profiler-AllocationCallGraph',
	#package : 'AllocationCallGraph-Profiler',
	#tag : 'AllocationCallGraph'
}

{ #category : 'allocation site' }
AllocationGraphSample class >> sendersCallStack: anIllSendersCallStack [ 

	^ self new
		sendersCallStack: anIllSendersCallStack;
		yourself
]

{ #category : 'accessing' }
AllocationGraphSample >> sendersCallStack [

	^ sendersCallStack
]

{ #category : 'allocation site' }
AllocationGraphSample >> sendersCallStack: anIllSendersCallStack [ 

	sendersCallStack := anIllSendersCallStack
]
