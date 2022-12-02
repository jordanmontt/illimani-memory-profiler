"
I am an object that will install and unistall the method proxies inside the methods: `basicNew` and `basicNew:`
"
Class {
	#name : #ObjectAllocationObserver,
	#superclass : #Object,
	#instVars : [
		'proxyHandler',
		'proxyA',
		'proxyB'
	],
	#category : #MethodProxiesSebas
}

{ #category : #accessing }
ObjectAllocationObserver >> allocations [

	^ proxyHandler allocations
]

{ #category : #initialization }
ObjectAllocationObserver >> initialize [

	super initialize.
	proxyHandler := MpColorAllocationProfilerHandler new.
	proxyA := MpMethodProxy onMethod: Behavior >> #basicNew handler: proxyHandler.
	proxyB := MpMethodProxy onMethod: Behavior >> #basicNew: handler: proxyHandler.
	
]

{ #category : #accessing }
ObjectAllocationObserver >> proxyHandler [

	^ proxyHandler
]

{ #category : #accessing }
ObjectAllocationObserver >> proxyHandler: aProxyHandler [

	proxyHandler := aProxyHandler.
	proxyA := MpMethodProxy onMethod: Behavior >> #basicNew handler: proxyHandler.
	proxyB := MpMethodProxy onMethod: Behavior >> #basicNew: handler: proxyHandler
]

{ #category : #api }
ObjectAllocationObserver >> startObserving [

	proxyA install.
	proxyB install
]

{ #category : #api }
ObjectAllocationObserver >> stopObserving [

	proxyA uninstall.
	proxyB uninstall
]
