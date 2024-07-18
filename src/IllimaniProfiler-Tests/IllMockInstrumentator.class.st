Class {
	#name : 'IllMockInstrumentator',
	#superclass : 'IllInstrumentator',
	#category : 'IllimaniProfiler-Tests-Allocations-Profiler',
	#package : 'IllimaniProfiler-Tests',
	#tag : 'Allocations-Profiler'
}

{ #category : 'initialization' }
IllMockInstrumentator >> initializeMethodProxies [

	proxyBasicNew := MpMethodProxy onMethod: Behavior >> #illNew handler: handler
]

{ #category : 'instrumentation' }
IllMockInstrumentator >> proxyVariables [

	^ { proxyBasicNew }
]
