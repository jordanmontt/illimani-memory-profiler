"
I am an object that will install and unistall the method proxies inside the methods: `basicNew` and `basicNew:`
"
Class {
	#name : #ObjectAllocationProfiler,
	#superclass : #Object,
	#instVars : [
		'proxyHandler',
		'proxyBasicNew',
		'proxyBasicNewKeyword'
	],
	#category : #AllocationProfiler
}

{ #category : #accessing }
ObjectAllocationProfiler >> allocations [

	^ proxyHandler allocations
]

{ #category : #initialization }
ObjectAllocationProfiler >> initialize [

	super initialize.
	proxyHandler := MpColorAllocationProfilerHandler new.
	proxyBasicNew := MpMethodProxy onMethod: Behavior >> #basicNew handler: proxyHandler.
	proxyBasicNewKeyword := MpMethodProxy onMethod: Behavior >> #basicNew: handler: proxyHandler.
	
]

{ #category : #accessing }
ObjectAllocationProfiler >> proxyHandler [

	^ proxyHandler
]

{ #category : #accessing }
ObjectAllocationProfiler >> proxyHandler: aProxyHandler [

	proxyHandler := aProxyHandler.
	proxyBasicNew := MpMethodProxy onMethod: Behavior >> #basicNew handler: proxyHandler.
	proxyBasicNewKeyword := MpMethodProxy onMethod: Behavior >> #basicNew: handler: proxyHandler
]

{ #category : #api }
ObjectAllocationProfiler >> startProfiling [

	proxyBasicNew install.
	proxyBasicNewKeyword install
]

{ #category : #api }
ObjectAllocationProfiler >> stopProfiling [

	proxyBasicNew uninstall.
	proxyBasicNewKeyword uninstall
]
