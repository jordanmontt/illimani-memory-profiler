"
I am a Memory Profiler.

I will put a proxy method  inside the methods: `basicNew` and `basicNew:` of the Behavior class. When you send the message `startProfiling` I will start to register the allocation of objects of the specified type. If no type is specified, I will capture all the allocations. You need to send the message `stopProfiling` to stop the registration.

Keep in mind that your image can get slow and big. The Pharo image allocate thousands, even houndreads of thousands, of objects per minute.
"
Class {
	#name : #ObjectAllocationProfiler,
	#superclass : #Object,
	#instVars : [
		'proxyBasicNew',
		'proxyBasicNewKeyword',
		'profilerHandler'
	],
	#category : #AllocationProfiler
}

{ #category : #accessing }
ObjectAllocationProfiler class >> defaultProfilerHandlerClass [

	^ MpMegaAllocationProfilerHandler
]

{ #category : #initialization }
ObjectAllocationProfiler >> initialize [

	super initialize.
	profilerHandler := self class defaultProfilerHandlerClass new.
	self installMethodProxies
]

{ #category : #api }
ObjectAllocationProfiler >> installMethodProxies [

	proxyBasicNew := MpMethodProxy onMethod: Behavior >> #basicNew handler: profilerHandler.
	proxyBasicNewKeyword := MpMethodProxy onMethod: Behavior >> #basicNew: handler: profilerHandler
]

{ #category : #accessing }
ObjectAllocationProfiler >> objectAllocations [

	^ profilerHandler objectAllocations
]

{ #category : #accessing }
ObjectAllocationProfiler >> profilerHandler [

	^ profilerHandler
]

{ #category : #accessing }
ObjectAllocationProfiler >> profilerHandler: anObjectAllocationProfilerHandler [

	profilerHandler := anObjectAllocationProfilerHandler.
	self installMethodProxies
]

{ #category : #api }
ObjectAllocationProfiler >> startProfiling [

	proxyBasicNew install.
	proxyBasicNewKeyword install
]

{ #category : #accessing }
ObjectAllocationProfiler >> stats [

	^ AllocationStatistics allocations: profilerHandler objectAllocations
]

{ #category : #api }
ObjectAllocationProfiler >> stopProfiling [

	proxyBasicNew uninstall.
	proxyBasicNewKeyword uninstall
]
