"
I profile the Garbage Collector and provide information about the lifetime of objects.
"
Class {
	#name : 'IllFinalizationProfiler',
	#superclass : 'Object',
	#traits : 'IllTAllocatorWrapper',
	#classTraits : 'IllTAllocatorWrapper classTrait',
	#instVars : [
		'profilerHandler',
		'finalizationRegistry'
	],
	#category : 'IllimaniFinalizationProfiler',
	#package : 'IllimaniFinalizationProfiler'
}

{ #category : 'api' }
IllFinalizationProfiler >> addFinalizationFor: newlyAllocatedObject finalizer: objectFinalizationModel [

	finalizationRegistry add: newlyAllocatedObject finalizer: objectFinalizationModel
]

{ #category : 'profiling' }
IllFinalizationProfiler >> forceFinalizationOfObjects [

	"We force the finalization timestamp for the not yet finalized objects."
	finalizationRegistry finalizeAllEphemerons.
	"Then we stop referencing the finalization registry to not re-finalize the objects."
	finalizationRegistry := self initializeFinalizationRegistry
]

{ #category : 'initialization' }
IllFinalizationProfiler >> initialize [

	super initialize.
	finalizationRegistry := self initializeFinalizationRegistry.
	profilerHandler := self initializeHandler.
	self initializeMethodProxies: profilerHandler
]

{ #category : 'initialization' }
IllFinalizationProfiler >> initializeFinalizationRegistry [

	^ FinalizationRegistry new
]

{ #category : 'initialization' }
IllFinalizationProfiler >> initializeHandler [

	^ IllFinalizationMpHandler new
		  profiler: self;
		  yourself
]

{ #category : 'api' }
IllFinalizationProfiler >> objectAllocations [

	^ profilerHandler objectAllocations
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
	"There is no stats model for this profiler yet"

	^ self
]

{ #category : 'profiling' }
IllFinalizationProfiler >> stopProfiling [

	self uninstallMethodProxies.
	self forceFinalizationOfObjects.
	self updateStatsWhenFinishingProfiling
]

{ #category : 'accessing - statistics' }
IllFinalizationProfiler >> timeDifferenceBetweenFirstAndLastAllocation [

	^ self objectAllocations last initializationTimestamp - self objectAllocations first initializationTimestamp
]

{ #category : 'accessing - statistics' }
IllFinalizationProfiler >> totalAllocatedMemory [

	^ self objectAllocations inject: 0 into: [ :sum : elem | sum + elem sizeInBytes ]
]

{ #category : 'accessing - statistics' }
IllFinalizationProfiler >> totalAllocatedObjects [

	^ self objectAllocations size
]
