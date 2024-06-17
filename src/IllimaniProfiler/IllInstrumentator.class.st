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
	#category : 'IllimaniProfiler-Instrumentation',
	#package : 'IllimaniProfiler',
	#tag : 'Instrumentation'
}

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
	proxyArrayClass := MpMethodProxy onMethod: Array class >> #new: handler: handler.
	proxyIntervalNew := MpMethodProxy onMethod: Interval class >> #new handler: handler.
	proxyArobas := MpMethodProxy onMethod: Number >> #@ handler: handler.
	
	"Copy and clone primitives"
	proxyCopy := MpMethodProxy onMethod: Object >> #shallowCopy handler: handler.
	proxyClone := MpMethodProxy onMethod: Object >> #clone handler: handler.
	proxyCompiledCodeClone := MpMethodProxy onMethod: CompiledCode >> #clone handler: handler.
	proxyExternalAddressClone := MpMethodProxy onMethod: ExternalAddress >> #clone handler: handler.
	proxyFixedBitWidthRegisterCopy := MpMethodProxy onMethod: FixedBitWidthRegister >> #copy handler: handler
]

{ #category : 'initialization' }
IllInstrumentator >> install [

	"Using reflexion to install the proxies"

	1 to: self class slots size do: [ :index |
		(self instVarAt: index) install ]
]

{ #category : 'initialization' }
IllInstrumentator >> profiler: aProfiler [

	profiler := aProfiler
]

{ #category : 'initialization' }
IllInstrumentator >> uninstall [

	"Using reflexion to uninstall the proxies"

	1 to: self class slots size do: [ :index |
		(self instVarAt: index) uninstall ]
]
