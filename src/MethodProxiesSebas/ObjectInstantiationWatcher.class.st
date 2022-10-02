"
I am an object that will install and unistall the method proxies inside the methods: `basicNew` and `basicNew:`
"
Class {
	#name : #ObjectInstantiationWatcher,
	#superclass : #Object,
	#instVars : [
		'proxyHandler',
		'proxyA',
		'proxyB'
	],
	#category : #MethodProxiesSebas
}

{ #category : #accessing }
ObjectInstantiationWatcher >> allocations [

	^ proxyHandler allocations
]

{ #category : #initialization }
ObjectInstantiationWatcher >> initialize [

	super initialize.
	proxyHandler := MpColorAllocationProfilerHandler new.
	proxyA := MpMethodProxy onMethod: Behavior >> #basicNew handler: proxyHandler.
	proxyB := MpMethodProxy onMethod: Behavior >> #basicNew: handler: proxyHandler.
	
]

{ #category : #accessing }
ObjectInstantiationWatcher >> proxyHandler [

	^ proxyHandler
]

{ #category : #accessing }
ObjectInstantiationWatcher >> proxyHandler: aProxyHandler [

	proxyHandler := aProxyHandler
]

{ #category : #api }
ObjectInstantiationWatcher >> startWatching [

	proxyA install.
	proxyB install
]

{ #category : #api }
ObjectInstantiationWatcher >> stopWatching [

	proxyA uninstall.
	proxyB uninstall
]
