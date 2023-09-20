Class {
	#name : 'IllimaniFinalizationProfilerFast',
	#superclass : 'IllimaniFinalizationProfiler',
	#classTraits : 'IllimaniTAllocatorWrapper classTrait',
	#category : 'IllimaniFinalizationProfiler',
	#package : 'IllimaniFinalizationProfiler'
}

{ #category : 'profiling' }
IllimaniFinalizationProfilerFast >> forceFinalizationOfObjects [

	profilerHandler forceFinalizationOfObjects
]

{ #category : 'initialization' }
IllimaniFinalizationProfilerFast >> initializeFinalizationRegistry [

	^ nil
]

{ #category : 'initialization' }
IllimaniFinalizationProfilerFast >> initializeHandler [

	^ IllimaniFinalizationMpHandlerFast new
]
