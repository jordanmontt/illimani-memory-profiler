Class {
	#name : 'IllFinalizationProfilerUnconstructedCollection',
	#superclass : 'Object',
	#traits : 'IllTAllocatorWrapper',
	#classTraits : 'IllTAllocatorWrapper classTrait',
	#instVars : [
		'profilerHandler',
		'statsModel'
	],
	#category : 'IllimaniFinalizationProfiler-Profiler',
	#package : 'IllimaniFinalizationProfiler',
	#tag : 'Profiler'
}

{ #category : 'profiling' }
IllFinalizationProfilerUnconstructedCollection >> forceFinalizationOfObjects [

	profilerHandler forceFinalizationOfObjects
]

{ #category : 'initialization' }
IllFinalizationProfilerUnconstructedCollection >> initialize [

	super initialize.
	profilerHandler := IllFinalizationMpHandlerUnconstructedCollection new.
	self initializeMethodProxies: profilerHandler
]

{ #category : 'profiling' }
IllFinalizationProfilerUnconstructedCollection >> objectAllocations [

	^ profilerHandler objectAllocations
]

{ #category : 'accessing - statistics' }
IllFinalizationProfilerUnconstructedCollection >> stats [

	^ statsModel ifNil: [ statsModel := FinalizationStatsModel on: self objectAllocations ]
]

{ #category : 'profiling' }
IllFinalizationProfilerUnconstructedCollection >> stopProfiling [

	self uninstallMethodProxies.
	self forceFinalizationOfObjects.
	self updateStatsWhenFinishingProfiling
]
