"
I am an object that is used to instrument all the allocator methods. I only serve for instrumenting and uninstrumenting the allocator methods.
"
Class {
	#name : 'IllInstrumenter',
	#superclass : 'Object',
	#instVars : [
		'handler',
		'profiler',
		'methodProxies'
	],
	#category : 'Illimani-FrameworkProfiler-Instrumentation',
	#package : 'Illimani-FrameworkProfiler',
	#tag : 'Instrumentation'
}

{ #category : 'api' }
IllInstrumenter class >> forceUninstall [
	"Warning, do not use unless you cannot start the profiler because you have the
	MpCannotInstall exception"

	MpMethodProxy allInstances do: #uninstall
]

{ #category : 'instance creation' }
IllInstrumenter class >> new [

	self error: 'Use #onProfiler:instrumentationHandler: instead'
]

{ #category : 'initialization' }
IllInstrumenter class >> onProfiler: aProfiler instrumentationHandler: anInstrumentationHandler [

	^ self basicNew
		profiler: aProfiler;
		handler: anInstrumentationHandler;
		initialize;
		yourself
]

{ #category : 'api' }
IllInstrumenter >> deinstrument [

	self disableInstrumentation.
	self uninstall
]

{ #category : 'instrumentation' }
IllInstrumenter >> disableInstrumentation [

	MpMethodProxy disableInstrumentation
]

{ #category : 'instrumentation' }
IllInstrumenter >> enableInstrumentation [

	MpMethodProxy enableInstrumentation
]

{ #category : 'api' }
IllInstrumenter >> forceUninstall [
	"Warning, do not use unless you cannot start the profiler because you have the
	MpCannotInstall exception"

	self class forceUninstall
]

{ #category : 'api - accessing' }
IllInstrumenter >> handler: anInstrumentationHandler [

    handler := anInstrumentationHandler
]

{ #category : 'initialization' }
IllInstrumenter >> initialize [

    super initialize.
    self initializeMethodProxies
]

{ #category : 'initialization' }
IllInstrumenter >> initializeMethodProxies [

    methodProxies := IllAllocatorMethodsConstant allocatorCompiledPrimitiveMethods
        collect: [ :compiledMethod | MpMethodProxy onMethod: compiledMethod handler: handler ]
]

{ #category : 'instrumentation' }
IllInstrumenter >> install [

	methodProxies do: #install
]

{ #category : 'api' }
IllInstrumenter >> instrument [

	self install.
	self enableInstrumentation
]

{ #category : 'api' }
IllInstrumenter >> profiler: aProfiler [

	profiler := aProfiler
]

{ #category : 'instrumentation' }
IllInstrumenter >> uninstall [

	methodProxies do: #uninstall
]
