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

{ #category : 'accessing - statistics' }
IllMemoryProfiler >> allocationsStats [

	self isProfilingFinished
		ifFalse: [ ^ Warning signal: 'Need to wait until the profiling is finished to access the stats' ].

	^ statsModel ifNil: [
		  statsModel := IllStatisticsModel objectAllocations: ephemeronsCollection totalProfiledTime: endTime ]
]

{ #category : 'exporting' }
IllMemoryProfiler >> exporterClass [

	^ IllMemoryProfilerExporter
]

{ #category : 'profiling' }
IllMemoryProfiler >> forceFinalizationOfObjects [

	ephemeronsCollection do: [ :e | e forceFinalization ]
]

{ #category : 'initialization' }
IllMemoryProfiler >> initialize [

	super initialize.
	ephemeronsCollection := OrderedCollection new: 100000000
]

{ #category : 'profiling' }
IllMemoryProfiler >> internalRegisterAllocation: newlyAllocatedObject [

	| metaClass filteredContext |

	metaClass := newlyAllocatedObject class class.

	filteredContext := thisContext
		sender "this is me, this profiler"
		sender "this is the AbstractProfiler (my super class)"
		sender "this is the IllHandler"
		sender. "this is the trapped instrumented method"

	[ "get out of the receiver. E.g. the new method"
	filteredContext receiver class = metaClass ] whileTrue:
		[ filteredContext := filteredContext sender ].

	ephemeronsCollection add: (IllEphemeron newTenured
		key: newlyAllocatedObject value: nil;
		allocatorMethod: filteredContext compiledCode method;
		programCounter: filteredContext pc;
		senders: filteredContext;
		yourself)
]

{ #category : 'accessing' }
IllMemoryProfiler >> objectAllocations [

	^ ephemeronsCollection
]

{ #category : 'profiling' }
IllMemoryProfiler >> stopProfiling [

	super stopProfiling.
	self forceFinalizationOfObjects
]
