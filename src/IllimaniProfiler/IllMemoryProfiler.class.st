Class {
	#name : 'IllMemoryProfiler',
	#superclass : 'IllAbstractProfiler',
	#instVars : [
		'ephemeronsCollection',
		'statsModel'
	],
	#category : 'IllimaniProfiler-Profiler',
	#package : 'IllimaniProfiler',
	#tag : 'Profiler'
}

{ #category : 'exporting' }
IllMemoryProfiler >> exporterClass [

	^ IllMemoryProfilerExporter
]

{ #category : 'profiling' }
IllMemoryProfiler >> forceFinalizationOfObjects [

	ephemeronsCollection do: [ :e | e mourn ]
]

{ #category : 'initialization' }
IllMemoryProfiler >> initialize [

	super initialize.
	ephemeronsCollection := OrderedCollection new: 100000000
]

{ #category : 'profiling' }
IllMemoryProfiler >> internalRegisterAllocation: newlyAllocatedObject [

	| metaClass filteredContext illEphemeron allocationSenderChain i |
	metaClass := newlyAllocatedObject class class.
	illEphemeron := IllEphemeron newTenured.
	i := 1.
	allocationSenderChain := Array new: 10.

	filteredContext := thisContext
		sender "this is me, this profiler"
		sender "this is the AbstractProfiler (my super class)"
		sender "this is the IllHandler"
		sender. "this is the trapped instrumented method (allocator method e.g. #basicNew)"

	"get out of the receiver. E.g. the new method"
	[ filteredContext receiver class = metaClass ] whileTrue: [
		allocationSenderChain
			at: i put: filteredContext compiledCode method;
			at: i + 1 put: filteredContext pc - 1.
		i := i + 2.
		filteredContext := filteredContext sender ].

	ephemeronsCollection add: (illEphemeron
			 allocationSenderChain: allocationSenderChain;
			 key: newlyAllocatedObject value: nil;
			 allocatorMethod: filteredContext compiledCode;
			 offset: filteredContext pc -1;
			 sendersCallStack: filteredContext;
			 yourself)
]

{ #category : 'accessing' }
IllMemoryProfiler >> objectAllocations [

	^ ephemeronsCollection
]

{ #category : 'accessing - statistics' }
IllMemoryProfiler >> queryAllocationStats [

	self isProfilingFinished
		ifFalse: [ ^ Warning signal: 'Need to wait until the profiling is finished to access the stats' ].

	^ statsModel ifNil: [
		  statsModel := IllStatisticsModel objectAllocations: ephemeronsCollection totalProfiledTime: endTime ]
]

{ #category : 'profiling' }
IllMemoryProfiler >> stopProfiling [

	super stopProfiling.
	self forceFinalizationOfObjects
]
