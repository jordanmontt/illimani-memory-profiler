Class {
	#name : 'IllFinalizationProfilerFast',
	#superclass : 'IllFinalizationProfiler',
	#classTraits : 'IllTAllocatorWrapper classTrait',
	#category : 'IllimaniFinalizationProfiler',
	#package : 'IllimaniFinalizationProfiler'
}

{ #category : 'profiling' }
IllFinalizationProfilerFast >> forceFinalizationOfObjects [

	profilerHandler forceFinalizationOfObjects
]

{ #category : 'initialization' }
IllFinalizationProfilerFast >> initializeFinalizationRegistry [

	^ nil
]

{ #category : 'initialization' }
IllFinalizationProfilerFast >> initializeHandler [

	^ IllFinalizationMpHandlerFast new
]
