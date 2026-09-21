Class {
	#name : 'IllAllocatorMethodsInstrumenter',
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
		'handler'
	],
	#category : 'Illimani-FrameworkProfiler-Instrumentation',
	#package : 'Illimani-FrameworkProfiler',
	#tag : 'Instrumentation'
}

{ #category : 'initialization' }
IllAllocatorMethodsInstrumenter >> handler: anInstrumentationHandler [

    handler := anInstrumentationHandler
]

{ #category : 'initialization' }
IllAllocatorMethodsInstrumenter >> initializeMethodProxies [

	"Basic new primitives"
	proxyBasicNew := MpMethodProxy onMethod: Behavior >> #basicNew handler: handler.
	proxyBasicNewKeyword := MpMethodProxy onMethod: Behavior >> #basicNew: handler: handler.
	proxyNewPinned := MpMethodProxy onMethod: Behavior >> #basicNewPinned handler: handler.
	proxyNewPinnedKeyword := MpMethodProxy onMethod: Behavior >> #basicNewPinned: handler: handler.
	
	"Tenured primitives"
	proxyNewTenured := MpMethodProxy onMethod: Behavior >> #basicNewTenured handler: handler.
	proxyNewTenuredKeyword := MpMethodProxy onMethod: Behavior >> #basicNewTenured: handler: handler.

	"Specialized primitives"
	proxyArrayClass := MpMethodProxy onMethod: (Array class lookupSelector: #new:) handler: handler.
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
IllAllocatorMethodsInstrumenter >> proxyVariables [

	| proxyVariables |
	self flag:
		'Important: Each time that a new proxy instance variable is added, one needs to add it to this array too.'.

    proxyVariables := { 
            proxyBasicNew.   proxyBasicNewKeyword.   proxyNewPinned.  proxyNewPinnedKeyword.
            proxyNewTenured. proxyNewTenuredKeyword. proxyArrayClass. proxyIntervalNew. 
            proxyArobas.     proxyCopy.              proxyClone.      proxyCompiledCodeClone.
            proxyExternalAddressClone. proxyFixedBitWidthRegisterCopy }.

	self assert: proxyVariables size = (self class slots size - 1).

	^ proxyVariables
]
