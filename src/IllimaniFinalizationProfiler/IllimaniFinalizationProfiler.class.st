"
I profile the Garbage Collector and provide information about the lifetime of objects.
"
Class {
	#name : 'IllimaniFinalizationProfiler',
	#superclass : 'Object',
	#traits : 'IllimaniTAllocatorWrapper',
	#classTraits : 'IllimaniTAllocatorWrapper classTrait',
	#instVars : [
		'profilerHandler',
		'finalizationRegistry'
	],
	#category : 'IllimaniFinalizationProfiler',
	#package : 'IllimaniFinalizationProfiler'
}

{ #category : 'api' }
IllimaniFinalizationProfiler >> addFinalizationFor: newlyAllocatedObject finalizer: objectFinalizationModel [

	finalizationRegistry add: newlyAllocatedObject finalizer: objectFinalizationModel
]

{ #category : 'profiling' }
IllimaniFinalizationProfiler >> cleanProfilingData [

	profilerHandler cleanObjectAllocations.
	finalizationRegistry := FinalizationRegistry new
]

{ #category : 'profiling' }
IllimaniFinalizationProfiler >> finalizeAllEphemerons [

	finalizationRegistry finalizeAllEphemerons
]

{ #category : 'profiling' }
IllimaniFinalizationProfiler >> forceFinalizationOfObjects [

	"We force the finalization timestamp for the not yet finalized objects."
	"finalizationRegistry valuesDo: #finalize."
	self finalizeAllEphemerons.
	"Then we stop referencing the finalization registry to not re-finalize the objects."
	finalizationRegistry := FinalizationRegistry new
]

{ #category : 'initialization' }
IllimaniFinalizationProfiler >> initialize [

	super initialize.
	finalizationRegistry := FinalizationRegistry new.
	profilerHandler := IllimaniFinalizationMpHandler new
		profiler: self;
		yourself.
	self initializeMethodProxies: profilerHandler
]

{ #category : 'initialization' }
IllimaniFinalizationProfiler >> objectAllocations [

	^ profilerHandler objectAllocations
]

{ #category : 'api' }
IllimaniFinalizationProfiler >> samplingRate: anInteger [

	profilerHandler samplingRate: anInteger
]

{ #category : 'profiling' }
IllimaniFinalizationProfiler >> startProfiling [

	self cleanProfilingData.
	self initializeProfilingBasicStats.
	self installMethodProxies
]

{ #category : 'accessing - statistics' }
IllimaniFinalizationProfiler >> stats [
	"There is no stats model for this profiler yet"

	^ self
]

{ #category : 'profiling' }
IllimaniFinalizationProfiler >> stopProfiling [

	self uninstallMethodProxies.
	self forceFinalizationOfObjects.
	self updateStatsWhenFinishingProfiling
]

{ #category : 'statistics - time' }
IllimaniFinalizationProfiler >> timeDifferenceBetweenFirstAndLastAllocation [

	^ self objectAllocations last initializationTimestamp - self objectAllocations first initializationTimestamp
]

{ #category : 'accessing' }
IllimaniFinalizationProfiler >> totalAllocatedMemory [

	^ self objectAllocations inject: 0 into: [ :sum : elem | sum + elem totalSizeInBytes ]
]

{ #category : 'accessing' }
IllimaniFinalizationProfiler >> totalAllocatedObjects [

	^ self objectAllocations size
]
