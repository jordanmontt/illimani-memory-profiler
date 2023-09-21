Class {
	#name : 'IllFinalizationProfilerUnconstructedCollection',
	#superclass : 'IllFinalizationProfiler',
	#classTraits : 'IllTAllocatorWrapper classTrait',
	#category : 'IllimaniFinalizationProfiler-Profiler',
	#package : 'IllimaniFinalizationProfiler',
	#tag : 'Profiler'
}

{ #category : 'profiling' }
IllFinalizationProfilerUnconstructedCollection >> forceFinalizationOfObjects [

	profilerHandler forceFinalizationOfObjects
]

{ #category : 'initialization' }
IllFinalizationProfilerUnconstructedCollection >> initializeHandler [

	^ IllFinalizationMpHandlerUnconstructedCollection new
]
