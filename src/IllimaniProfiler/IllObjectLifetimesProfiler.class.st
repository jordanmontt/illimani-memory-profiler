"
I am an object lifetimes profiler. I profile how much time do the objects live. I use finalization (ephemerons) in my implementation.
"
Class {
	#name : 'IllObjectLifetimesProfiler',
	#superclass : 'IllAbstractProfiler',
	#instVars : [
		'ephemeronsCollection',
		'statsModel'
	],
	#category : 'IllimaniProfiler-Object-Lifetimes-Profiler',
	#package : 'IllimaniProfiler',
	#tag : 'Object-Lifetimes-Profiler'
}

{ #category : 'accessing - statistics' }
IllObjectLifetimesProfiler >> allocationsStats [

	^ statsModel ifNil: [ statsModel := FinalizationStatsModel on: ephemeronsCollection ]
]

{ #category : 'exporting' }
IllObjectLifetimesProfiler >> exporterClass [

	^ IllObjectLifetimesExporter
]

{ #category : 'profiling' }
IllObjectLifetimesProfiler >> forceFinalizationOfObjects [

	ephemeronsCollection do: [ :e | e forceFinalization ]
]

{ #category : 'initialization' }
IllObjectLifetimesProfiler >> initialize [

	super initialize.
	ephemeronsCollection := OrderedCollection new: 100000000
]

{ #category : 'profiling' }
IllObjectLifetimesProfiler >> internalRegisterAllocation: newlyAllocatedObject [
	
	| metaClass filteredContext |
	
	metaClass := newlyAllocatedObject class class.

	filteredContext := thisContext
		sender "this is me, this profiler"
		sender "this is the AbstractProfiler (my super class)"
		sender "this is the IllHandler"
		sender "this is the trapped instrumented method".

	[ "get out of the receiver. E.g. the new method"
	filteredContext receiver class = metaClass ] whileTrue:
		[ filteredContext := filteredContext sender ].
	
	ephemeronsCollection add: (IllEphemeron newTenured 
		key: newlyAllocatedObject value: nil;
		allocationSite: filteredContext compiledCode method;
		yourself)
]

{ #category : 'accessing' }
IllObjectLifetimesProfiler >> objectAllocations [

	^ ephemeronsCollection
]

{ #category : 'profiling' }
IllObjectLifetimesProfiler >> stopProfiling [

	super stopProfiling.
	self forceFinalizationOfObjects
]
