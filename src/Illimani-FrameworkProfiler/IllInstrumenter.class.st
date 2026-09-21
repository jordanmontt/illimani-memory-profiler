"
I am an object that is used to instrument all the allocator methods. I only serve for instrumenting and uninstrumenting the allocator methods.
"
Class {
	#name : 'IllInstrumenter',
	#superclass : 'Object',
	#instVars : [
		'allocatorMethodsInstrumenter',
		'handler',
		'profiler'
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

	self error: 'Use onProfiler: instead'
]

{ #category : 'initialization' }
IllInstrumenter class >> onProfiler: aProfiler [

	^ self basicNew
		profiler: aProfiler;
		initialize;
		yourself
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

{ #category : 'initialization' }
IllInstrumenter >> initialize [

	super initialize.
	self initializeHandler.
	allocatorMethodsInstrumenter := IllAllocatorMethodsInstrumenter new handler: handler; yourself.
	self initializeMethodProxies
]

{ #category : 'initialization' }
IllInstrumenter >> initializeHandler [

	handler := IllHandler new
		profiler: profiler;
		yourself
]

{ #category : 'initialization' }
IllInstrumenter >> initializeMethodProxies [

    allocatorMethodsInstrumenter initializeMethodProxies
]

{ #category : 'instrumentation' }
IllInstrumenter >> install [

	self proxyVariables do: #install
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
IllInstrumenter >> proxyVariables [

    ^ allocatorMethodsInstrumenter proxyVariables
]

{ #category : 'instrumentation' }
IllInstrumenter >> uninstall [

	self proxyVariables do: #uninstall
]

{ #category : 'api' }
IllInstrumenter >> uninstrument [

	self disableInstrumentation.
	self uninstall
]
