Class {
	#name : 'IllMockInstrumentator',
	#superclass : 'Object',
	#instVars : [
		'proxyBasicNew',
		'handler',
		'profiler'
	],
	#category : 'Illimani-FrameworkProfiler-Tests-Utilities',
	#package : 'Illimani-FrameworkProfiler-Tests',
	#tag : 'Utilities'
}

{ #category : 'instance creation' }
IllMockInstrumentator class >> new [

	self error: 'Use onProfiler: instead'
]

{ #category : 'instance creation' }
IllMockInstrumentator class >> onProfiler: aProfiler [

    ^ self basicNew
          profiler: aProfiler;
          initialize;
          yourself
]

{ #category : 'initialization' }
IllMockInstrumentator >> deinstrument [

	self disableInstrumentation.
	self uninstall
]

{ #category : 'initialization' }
IllMockInstrumentator >> disableInstrumentation [

	MpMethodProxy disableInstrumentation
]

{ #category : 'initialization' }
IllMockInstrumentator >> enableInstrumentation [

	MpMethodProxy enableInstrumentation
]

{ #category : 'initialization' }
IllMockInstrumentator >> initialize [

    super initialize.

    handler := IllHandler new
                   profiler: profiler;
                   yourself.

    self initializeMethodProxies
]

{ #category : 'initialization' }
IllMockInstrumentator >> initializeMethodProxies [

	proxyBasicNew := MpMethodProxy onMethod: Behavior >> #illNew handler: handler
]

{ #category : 'initialization' }
IllMockInstrumentator >> install [

	proxyBasicNew install
]

{ #category : 'initialization' }
IllMockInstrumentator >> instrument [

	self install.
	self enableInstrumentation
]

{ #category : 'initialization' }
IllMockInstrumentator >> profiler: aProfiler [

    profiler := aProfiler
]

{ #category : 'initialization' }
IllMockInstrumentator >> uninstall [

	proxyBasicNew uninstall
]
