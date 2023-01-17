"
I am a Memory Profiler.

I will put a proxy method  inside the methods: `basicNew` and `basicNew:` of the Behavior class. When you send the message `startProfiling` I will start to register the allocation of objects of the specified type. If no type is specified, I will capture all the allocations. You need to send the message `stopProfiling` to stop the registration.

Keep in mind that your image can get slow and big. The Pharo image allocate thousands, even houndreads of thousands, of objects per minute.
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

{ #category : #api }
ObjectAllocationProfiler >> captureAll [

	proxyHandler := MpMegaAllocationProfilerHandler new.
	proxyBasicNew := MpMethodProxy onMethod: Behavior >> #basicNew handler: proxyHandler.
	proxyBasicNewKeyword := MpMethodProxy onMethod: Behavior >> #basicNew: handler: proxyHandler
]

{ #category : #api }
ObjectAllocationProfiler >> captureTheColors [

	proxyHandler := MpColorAllocationProfilerHandler new.
	proxyBasicNew := MpMethodProxy onMethod: Behavior >> #basicNew handler: proxyHandler.
	proxyBasicNewKeyword := MpMethodProxy onMethod: Behavior >> #basicNew: handler: proxyHandler.
]

{ #category : #initialization }
ObjectAllocationProfiler >> initialize [

	super initialize.
	self captureAll
]

{ #category : #accessing }
ObjectAllocationProfiler >> objectAllocations [

	^ proxyHandler objectAllocations
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

{ #category : #accessing }
ObjectAllocationProfiler >> stats [

	^ AllocationStatistics allocations: proxyHandler objectAllocations
]

{ #category : #api }
ObjectAllocationProfiler >> stopProfiling [

	proxyBasicNew uninstall.
	proxyBasicNewKeyword uninstall
]
