"
I am a no action profiler. I am useful to test the introduced overhead of only instrumenting the methods but without taking no action. I DO NOTHING. I ONLY INSTRUMENT THE ALLOCATOR METHODS.
"
Class {
	#name : 'IllNoActionProfiler',
	#superclass : 'IllAbstractProfiler',
	#category : 'IllimaniProfiler-Instrumentation',
	#package : 'IllimaniProfiler',
	#tag : 'Instrumentation'
}

{ #category : 'initialization' }
IllNoActionProfiler >> initialize [

	super initialize.
	"As we call super before, we are re-doing the initialization of the method proxies.
	But, it's not a problem since we didn't start instrumenting."
	handler := IllNoActionHandler new
		profiler: self;
		yourself.
	self initializeMethodProxies: handler
]

{ #category : 'profiling' }
IllNoActionProfiler >> internalRegisterAllocation: anObject [

	"Do nothing"
]

{ #category : 'accessing' }
IllNoActionProfiler >> objectAllocations [

	^ {  }
]

{ #category : 'accessing - statistics' }
IllNoActionProfiler >> stats [
	"Yes, it's not needed but it just to make clear that we do nothing"

	^ self
]
