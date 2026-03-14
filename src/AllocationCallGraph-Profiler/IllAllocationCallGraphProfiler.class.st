Class {
	#name : 'IllAllocationCallGraphProfiler',
	#superclass : 'IllAbstractProfiler',
	#instVars : [
		'allocationStacks',
		'allocationCallGraph'
	],
	#category : 'AllocationCallGraph-Profiler-Profiler',
	#package : 'AllocationCallGraph-Profiler',
	#tag : 'Profiler'
}

{ #category : 'accessing' }
IllAllocationCallGraphProfiler >> allocationCallGraph [

	^ allocationCallGraph ifNil: [
		| samples |
		samples := allocationStacks collect: [ :callStack |
				AllocationGraphSample sendersCallStack: (IllSendersCallStack senders: callStack) ].
		allocationCallGraph := AllocationGraph new
				setUpForSamples: samples;
				yourself ]
]

{ #category : 'initialization' }
IllAllocationCallGraphProfiler >> initialize [

	super initialize.
	allocationStacks := OrderedCollection new: 1000000
]

{ #category : 'profiling' }
IllAllocationCallGraphProfiler >> internalRegisterAllocation: anObject [

	| filteredContext thisAllocationStack i n |
	i := 1.
	n := 100.
	thisAllocationStack := Array new: n.

	filteredContext := thisContext "proxy method"
		sender "FiLiP >> #internalRegisterAllocation:"
		sender "IllAbstractProfiler >> #registerAllocation:"
		sender "IllHandler >> #afterExecutionWithReceiver:returnValue:"
		"sender". "this is the instrumented method (allocator method e.g. #basicNew)"

	"Get the rest of the stack until a limit n"
	[ filteredContext isNil or: [ i > n ] ] whileFalse: [
		thisAllocationStack
			at: i put: filteredContext compiledCode;
		 	at: i + 1 put: filteredContext pc - 1.
		i := i + 2.
		filteredContext := filteredContext sender ].

	allocationStacks add: thisAllocationStack
]
