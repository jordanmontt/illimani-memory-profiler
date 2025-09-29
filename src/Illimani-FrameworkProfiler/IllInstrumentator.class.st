"
I am an object that is used to instrument all the allocator methods. I only serve for instrumenting and uninstrumenting the allocator methods.
"
Class {
	#name : 'IllInstrumentator',
	#superclass : 'Object',
	#instVars : [
		'proxyBasicNew',
		'proxyBasicNewKeyword',
		'proxyNewPinned',
		'proxyNewPinnedKeyword',
		'proxyNewTenured',
		'proxyNewTenuredKeyword',
		'proxyArrayClass',
		'proxyIntervalNew',
		'proxyArobas',
		'proxyCopy',
		'proxyClone',
		'proxyCompiledCodeClone',
		'proxyExternalAddressClone',
		'proxyFixedBitWidthRegisterCopy',
		'handler',
		'profiler'
	],
	#category : 'Illimani-FrameworkProfiler-Instrumentation',
	#package : 'Illimani-FrameworkProfiler',
	#tag : 'Instrumentation'
}

{ #category : 'api' }
IllInstrumentator class >> forceUninstall [
	"Warning, do not use unless you cannot start the profiler because you have the
	MpCannotInstall exception"

	MpMethodProxy allInstances do: #uninstall
]

{ #category : 'instance creation' }
IllInstrumentator class >> new [

	self error: 'Use onProfiler: instead'
]

{ #category : 'initialization' }
IllInstrumentator class >> onProfiler: aProfiler [

	^ self basicNew
		profiler: aProfiler;
		initialize;
		yourself
]

{ #category : 'instrumentation' }
IllInstrumentator >> disableInstrumentation [

	MpMethodProxy disableInstrumentation
]

{ #category : 'instrumentation' }
IllInstrumentator >> enableInstrumentation [

	MpMethodProxy enableInstrumentation
]

{ #category : 'api' }
IllInstrumentator >> forceUninstall [
	"Warning, do not use unless you cannot start the profiler because you have the
	MpCannotInstall exception"

	self class forceUninstall
]

{ #category : 'initialization' }
IllInstrumentator >> initialize [

	super initialize.
	self initializeHandler.
	self initializeMethodProxies
]

{ #category : 'initialization' }
IllInstrumentator >> initializeHandler [

	handler := IllHandler new
		profiler: profiler;
		yourself
]

{ #category : 'initialization' }
IllInstrumentator >> initializeMethodProxies [

	"Basic new primitives"
	proxyBasicNew := MpMethodProxy onMethod: Behavior >> #basicNew handler: handler.
	proxyBasicNewKeyword := MpMethodProxy onMethod: Behavior >> #basicNew: handler: handler.
	proxyNewPinned := MpMethodProxy onMethod: Behavior >> #basicNewPinned handler: handler.
	proxyNewPinnedKeyword := MpMethodProxy onMethod: Behavior >> #basicNewPinned: handler: handler.
	proxyNewTenured := MpMethodProxy onMethod: Behavior >> #basicNewTenured handler: handler.
	proxyNewTenuredKeyword := MpMethodProxy onMethod: Behavior >> #basicNewTenured: handler: handler.

	"Specialized primitives"
	proxyArrayClass := MpMethodProxy onMethod: ArrayedCollection class >> #new: handler: handler.
	proxyIntervalNew := MpMethodProxy onMethod: Interval class >> #new handler: handler.
	proxyArobas := MpMethodProxy onMethod: Number >> #@ handler: handler.

	"Copy and clone primitives"
	proxyCopy := MpMethodProxy onMethod: Object >> #shallowCopy handler: handler.
	proxyClone := MpMethodProxy onMethod: Object >> #clone handler: handler.
	proxyCompiledCodeClone := MpMethodProxy onMethod: CompiledCode >> #clone handler: handler.
	proxyExternalAddressClone := MpMethodProxy onMethod: ExternalAddress >> #clone handler: handler.
	proxyFixedBitWidthRegisterCopy := MpMethodProxy onMethod: FixedBitWidthRegister >> #copy handler: handler
]

{ #category : 'instrumentation' }
IllInstrumentator >> install [

	self proxyVariables do: #install
]

{ #category : 'api' }
IllInstrumentator >> instrument [

	self install.
	self enableInstrumentation
]

{ #category : 'api' }
IllInstrumentator >> profiler: aProfiler [

	profiler := aProfiler
]

{ #category : 'instrumentation' }
IllInstrumentator >> proxyVariables [

	| proxyVariables |
	self flag:
		'Important: Each time that a new proxy instance variable is added, one needs to add it to this array too.'.

	proxyVariables := { proxyBasicNew. proxyBasicNewKeyword. proxyNewPinned. proxyNewPinnedKeyword. proxyNewTenured. 
				proxyNewTenuredKeyword. proxyArrayClass. proxyIntervalNew. proxyArobas. proxyCopy. proxyClone. 
				proxyCompiledCodeClone. proxyExternalAddressClone. proxyFixedBitWidthRegisterCopy }.

	^ proxyVariables
]

{ #category : 'instrumentation' }
IllInstrumentator >> uninstall [

	self proxyVariables do: #uninstall
]

{ #category : 'api' }
IllInstrumentator >> uninstrument [

	self disableInstrumentation.
	self uninstall
]
