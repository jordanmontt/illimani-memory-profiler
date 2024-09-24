"
I am a no action profiler. I execute no action. But, I instrument all the allocator methods any way. I am useful to test the introduced overhead of only instrumenting the methods but without taking no action.
"
Class {
	#name : 'IllNoActionProfiler',
	#superclass : 'IllAbstractProfiler',
	#category : 'IllimaniProfiler-Profiler',
	#package : 'IllimaniProfiler',
	#tag : 'Profiler'
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
