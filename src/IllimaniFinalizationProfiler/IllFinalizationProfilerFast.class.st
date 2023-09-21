Class {
	#name : 'IllFinalizationProfilerFast',
	#superclass : 'Object',
	#traits : 'IllTAllocatorWrapper',
	#classTraits : 'IllTAllocatorWrapper classTrait',
	#instVars : [
		'ephemeronsCollection'
	],
	#category : 'IllimaniFinalizationProfiler-Profiler',
	#package : 'IllimaniFinalizationProfiler',
	#tag : 'Profiler'
}

{ #category : 'profiling' }
IllFinalizationProfilerFast >> forceFinalizationOfObjects [

	ephemeronsCollection do: [ :e | e mourn ]
]

{ #category : 'initialization' }
IllFinalizationProfilerFast >> initialize [

	super initialize.
	ephemeronsCollection := OrderedCollection new: 10000000
]

{ #category : 'initialization' }
IllFinalizationProfilerFast >> initializeHandler [

	^ IllFinalizationMpHandlerFast new
		profiler: self;
		yourself
]

{ #category : 'api' }
IllFinalizationProfilerFast >> objectAllocations [

	^ ephemeronsCollection
]

{ #category : 'profiling' }
IllFinalizationProfilerFast >> registerAllocation: anObject [

	ephemeronsCollection add: (IllEphemeron newPinned 
		key: anObject value: nil;
		initializationTime: Time primUTCMicrosecondsClock;
		allocatedObjectClass: anObject class;
		sizeInBytes: anObject sizeInMemory;
		yourself)
]

{ #category : 'profiling' }
IllFinalizationProfilerFast >> startProfiling [

	self initializeProfilingBasicStats.
	self installMethodProxies
]

{ #category : 'accessing - statistics' }
IllFinalizationProfilerFast >> stats [
	"There is no stats model for this profiler yet"

	^ self
]

{ #category : 'profiling' }
IllFinalizationProfilerFast >> stopProfiling [

	self uninstallMethodProxies.
	self forceFinalizationOfObjects.
	self updateStatsWhenFinishingProfiling
]

{ #category : 'accessing' }
IllFinalizationProfilerFast >> totalAllocatedMemory [

	^ self objectAllocations inject: 0 into: [ :sum : elem | sum + elem sizeInBytes ]
]

{ #category : 'accessing' }
IllFinalizationProfilerFast >> totalAllocatedObjects [

	^ self objectAllocations size
]
