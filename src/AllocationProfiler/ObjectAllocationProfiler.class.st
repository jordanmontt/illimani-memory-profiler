"
I am an object that will install and unistall the method proxies inside the methods: `basicNew` and `basicNew:`
"
Class {
	#name : #ObjectAllocationProfiler,
	#superclass : #Object,
	#instVars : [
		'proxyHandler',
		'proxyA',
		'proxyB'
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
	proxyA := MpMethodProxy onMethod: Behavior >> #basicNew handler: proxyHandler.
	proxyB := MpMethodProxy onMethod: Behavior >> #basicNew: handler: proxyHandler.
	
]

{ #category : #accessing }
ObjectAllocationProfiler >> proxyHandler [

	^ proxyHandler
]

{ #category : #accessing }
ObjectAllocationProfiler >> proxyHandler: aProxyHandler [

	proxyHandler := aProxyHandler.
	proxyA := MpMethodProxy onMethod: Behavior >> #basicNew handler: proxyHandler.
	proxyB := MpMethodProxy onMethod: Behavior >> #basicNew: handler: proxyHandler
]

{ #category : #api }
ObjectAllocationProfiler >> startProfiling [

	proxyA install.
	proxyB install
]

{ #category : #api }
ObjectAllocationProfiler >> stopProfiling [

	proxyA uninstall.
	proxyB uninstall
]
