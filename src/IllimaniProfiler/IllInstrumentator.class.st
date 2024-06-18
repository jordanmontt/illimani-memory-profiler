"
I am an object that is used to instrument the allocator method. I only serve for instrumenting and uninstrumenting the allocator methods. I am used by the profiler.
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

	self proxyVariables do: #install
]

{ #category : 'initialization' }
IllInstrumentator >> profiler: aProfiler [

	profiler := aProfiler
]

{ #category : 'initialization' }
IllInstrumentator >> proxyVariables [

	self flag:
		'Important: Each time that a new proxy instance variable is added, one needs to add it to this array too.'.
	^ {
		  proxyBasicNew.
		  proxyBasicNewKeyword.
		  proxyNewPinned.
		  proxyNewPinnedKeyword.
		  proxyNewTenured.
		  proxyNewTenuredKeyword.
		  proxyArrayClass.
		  proxyIntervalNew.
		  proxyArobas.
		  proxyCopy.
		  proxyClone.
		  proxyCompiledCodeClone.
		  proxyExternalAddressClone.
		  proxyFixedBitWidthRegisterCopy }
]

{ #category : 'initialization' }
IllInstrumentator >> uninstall [

	self proxyVariables do: #uninstall
]
