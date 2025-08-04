Class {
	#name : 'IllMockInstrumentator',
	#superclass : 'IllInstrumentator',
	#category : 'Illimani-FrameworkProfiler-Tests-Utilities',
	#package : 'Illimani-FrameworkProfiler-Tests',
	#tag : 'Utilities'
}

{ #category : 'initialization' }
IllMockInstrumentator >> initializeMethodProxies [

	proxyBasicNew := MpMethodProxy onMethod: Behavior >> #illNew handler: handler
]

{ #category : 'instrumentation' }
IllMockInstrumentator >> proxyVariables [

	^ { proxyBasicNew }
]
