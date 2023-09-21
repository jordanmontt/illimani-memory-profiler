Class {
	#name : 'IllFinalizationProfiler',
	#superclass : 'Object',
	#traits : 'IllTAllocatorWrapper',
	#classTraits : 'IllTAllocatorWrapper classTrait',
	#instVars : [
		'ephemeronsCollection',
		'profilerHandler',
		'statsModel',
		'samplingRate',
		'samplingCounter'
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
	profilerHandler := IllFinalizationMpHandler new
		profiler: self;
		yourself.
	samplingCounter := 0.
	samplingRate := 1.
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

	"Sampling"
	"samplingCounter := samplingCounter + 1.
	samplingCounter % samplingRate = 0 ifFalse: [ ^ newlyAllocatedObject ]."
	
	ephemeronsCollection add: (IllEphemeron newPinned 
		key: anObject value: nil;
		initializationTime: Time primUTCMicrosecondsClock;
		allocatedObjectClass: anObject class;
		sizeInBytes: anObject sizeInMemory;
		yourself)
]

{ #category : 'api' }
IllFinalizationProfiler >> samplingRate: anInteger [
	"The anInteger needs to be an integer number between 1 and 100 that represents the sampling percentage"

	samplingRate := (100 / anInteger) asInteger
]

{ #category : 'accessing - statistics' }
IllFinalizationProfiler >> stats [

	^ statsModel ifNil: [ statsModel := FinalizationStatsModel on: ephemeronsCollection ]
]

{ #category : 'profiling' }
IllFinalizationProfiler >> stopProfiling [

	self uninstallMethodProxies.
	self forceFinalizationOfObjects.
	self updateStatsWhenFinishingProfiling
]
