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
IllObjectLifetimesProfiler >> internalRegisterAllocation: anObject [
	
	ephemeronsCollection add: (IllEphemeron newTenured 
		key: anObject value: nil;
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
