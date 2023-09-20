Class {
	#name : 'IllimaniFinalizationProfilerFast',
	#superclass : 'IllimaniFinalizationProfiler',
	#traits : 'IllimaniTAllocatorWrapper',
	#classTraits : 'IllimaniTAllocatorWrapper classTrait',
	#category : 'IllimaniFinalizationProfiler',
	#package : 'IllimaniFinalizationProfiler'
}

{ #category : 'api' }
IllimaniFinalizationProfilerFast >> addFinalizationFor: newlyAllocatedObject [

	finalizationRegistry add: newlyAllocatedObject finalizer: IllimaniGlobalFinalizer default
]

{ #category : 'initialization' }
IllimaniFinalizationProfilerFast >> finalizationRegistryClass [

	^ IllimaniFinalizationRegistry
]

{ #category : 'initialization' }
IllimaniFinalizationProfilerFast >> handlerClass [

	^ IllimaniFinalizationMpHandlerFast
]
