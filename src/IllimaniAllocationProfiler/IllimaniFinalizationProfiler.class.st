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
	#category : 'IllimaniAllocationProfiler-Finalization Profiler',
	#package : 'IllimaniAllocationProfiler',
	#tag : 'Finalization Profiler'
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

{ #category : 'profiling' }
IllimaniFinalizationProfiler >> isProfiling [

	^ gcProcess isNotNil
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

{ #category : 'profiling' }
IllimaniFinalizationProfiler >> stopProfiling [
	
	self uninstallMethodProxies.
	self forceFinalizationOfObjects.
	self updateStatsWhenFinishingProfiling
]
