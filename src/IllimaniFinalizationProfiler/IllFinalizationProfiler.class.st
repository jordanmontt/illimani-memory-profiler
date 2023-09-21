Class {
	#name : 'IllFinalizationProfiler',
	#superclass : 'Object',
	#traits : 'IllTAllocatorWrapper',
	#classTraits : 'IllTAllocatorWrapper classTrait',
	#instVars : [
		'ephemeronsCollection',
		'profilerHandler',
		'statsModel'
	],
	#category : 'IllimaniFinalizationProfiler-Profiler',
	#package : 'IllimaniFinalizationProfiler',
	#tag : 'Profiler'
}

{ #category : 'profiling' }
IllFinalizationProfiler >> forceFinalizationOfObjects [

	ephemeronsCollection do: [ :e | e mourn ]
]

{ #category : 'initialization' }
IllFinalizationProfiler >> initialize [

	super initialize.
	ephemeronsCollection := OrderedCollection new: 10000000.
	profilerHandler := IllFinalizationMpHandlerFast new
		profiler: self;
		yourself.
	self initializeMethodProxies: profilerHandler
]

{ #category : 'api' }
IllFinalizationProfiler >> objectAllocations [

	^ ephemeronsCollection
]

{ #category : 'instance creation' }
IllFinalizationProfiler >> open [

	^ (IllFinalizationProfilerUI profiler: self announcer: IllAnnouncer new)
		  open;
		  yourself
]

{ #category : 'profiling' }
IllFinalizationProfiler >> registerAllocation: anObject [

	ephemeronsCollection add: (IllEphemeron newPinned 
		key: anObject value: nil;
		initializationTime: Time primUTCMicrosecondsClock;
		allocatedObjectClass: anObject class;
		sizeInBytes: anObject sizeInMemory;
		yourself)
]

{ #category : 'api' }
IllFinalizationProfiler >> samplingRate: anInteger [

	profilerHandler samplingRate: anInteger
]

{ #category : 'profiling' }
IllFinalizationProfiler >> startProfiling [

	self initializeProfilingBasicStats.
	self installMethodProxies
]

{ #category : 'accessing - statistics' }
IllFinalizationProfiler >> stats [

	^ statsModel ifNil: [ statsModel := IllFinalizationStatsModel on: ephemeronsCollection ]
]

{ #category : 'profiling' }
IllFinalizationProfiler >> stopProfiling [

	self uninstallMethodProxies.
	self forceFinalizationOfObjects.
	self updateStatsWhenFinishingProfiling
]
