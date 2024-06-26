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

{ #category : 'accessing - statistics' }
IllNoActionProfiler >> allocationsStats [
	"Yes, it's not needed but it just to make clear that we do nothing"

	^ self
]

{ #category : 'initialization' }
IllNoActionProfiler >> initialize [

	super initialize.
	"As we call super before, we are re-doing the initialization of the method proxies.
	But, it's not a problem since we didn't start instrumenting."
	instrumentator := IllInstrumentatorNoAction onProfiler: self
]

{ #category : 'profiling' }
IllNoActionProfiler >> internalRegisterAllocation: anObject [

	"Do nothing"
]

{ #category : 'accessing' }
IllNoActionProfiler >> objectAllocations [

	^ {  }
]
