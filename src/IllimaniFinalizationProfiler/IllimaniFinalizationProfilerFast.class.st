Class {
	#name : 'IllimaniFinalizationProfilerFast',
	#superclass : 'IllimaniFinalizationProfiler',
	#classTraits : 'IllimaniTAllocatorWrapper classTrait',
	#category : 'IllimaniFinalizationProfiler',
	#package : 'IllimaniFinalizationProfiler'
}

{ #category : 'api' }
IllimaniFinalizationProfilerFast >> addFinalizationFor: newlyAllocatedObject [

	finalizationRegistry add: newlyAllocatedObject finalizer: IllimaniGlobalFinalizer default
]

{ #category : 'initialization' }
IllimaniFinalizationProfilerFast >> initializeFinalizationRegistry [

	^ IllimaniFinalizationRegistry new
]

{ #category : 'initialization' }
IllimaniFinalizationProfilerFast >> initializeHandler [

	^ IllimaniFinalizationMpHandlerFast new
]
