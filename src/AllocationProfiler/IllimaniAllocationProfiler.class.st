"
I am a Memory Profiler.

I will put a proxy method  inside the methods: `basicNew` and `basicNew:` of the Behavior class. When you send the message `startProfiling` I will start to register the allocation of objects of the specified type. If no type is specified, I will capture all the allocations. You need to send the message `stopProfiling` to stop the registration.

Keep in mind that your image can get slow and big. The Pharo image allocate thousands, even houndreads of thousands, of objects per minute.
"
Class {
	#name : #IllimaniAllocationProfiler,
	#superclass : #Object,
	#instVars : [
		'proxyBasicNew',
		'proxyBasicNewKeyword',
		'profilerHandler',
		'beginningOfProfilingTime',
		'endOfProfilingTime'
	],
	#category : #AllocationProfiler
}

{ #category : #api }
IllimaniAllocationProfiler class >> profileFor: seconds [

	| profiler |
	profiler := self new.
	[ profiler profileFor: seconds ] fork.
	^ profiler
]

{ #category : #api }
IllimaniAllocationProfiler class >> profileOn: aBlock [

	^ self new profileOn: aBlock
]

{ #category : #accessing }
IllimaniAllocationProfiler >> beginningOfProfilingTime [

	^ beginningOfProfilingTime
]

{ #category : #api }
IllimaniAllocationProfiler >> captureAllObjects [

	profilerHandler captureAllObjects
]

{ #category : #evaluating }
IllimaniAllocationProfiler >> cleanProfilingData [

	profilerHandler cleanAllocations.
	beginningOfProfilingTime := nil.
	endOfProfilingTime := nil
]

{ #category : #api }
IllimaniAllocationProfiler >> copyExecutionStack [

	profilerHandler copyExecutionStack
]

{ #category : #accessing }
IllimaniAllocationProfiler >> endOfProfilingTime [

	^ endOfProfilingTime
]

{ #category : #initialization }
IllimaniAllocationProfiler >> initialize [

	super initialize.
	profilerHandler := IllimaniProfilerMpHandler new.
	self initializeMethodProxies
]

{ #category : #evaluating }
IllimaniAllocationProfiler >> initializeMethodProxies [

	proxyBasicNew := MpMethodProxy onMethod: Behavior >> #basicNew handler: profilerHandler.
	proxyBasicNewKeyword := MpMethodProxy onMethod: Behavior >> #basicNew: handler: profilerHandler
]

{ #category : #testing }
IllimaniAllocationProfiler >> isProfilingFinished [

	^ endOfProfilingTime isNil not
]

{ #category : #testing }
IllimaniAllocationProfiler >> isProfilingStarted [

	^ beginningOfProfilingTime isNil not
]

{ #category : #accessing }
IllimaniAllocationProfiler >> objectAllocations [

	^ profilerHandler objectAllocations
]

{ #category : #api }
IllimaniAllocationProfiler >> profileFor: seconds [
	"Done with a fork because we don't want to block the ui thread since it allocates objects. "

	self startProfiling.
	[
	(Delay forSeconds: seconds) wait.
	self stopProfiling ] fork
]

{ #category : #api }
IllimaniAllocationProfiler >> profileOn: aBlock [

	self startProfiling.
	aBlock ensure: [ self stopProfiling ]
]

{ #category : #accessing }
IllimaniAllocationProfiler >> profilerHandler [

	^ profilerHandler
]

{ #category : #evaluating }
IllimaniAllocationProfiler >> startProfiling [

	self cleanProfilingData.
	beginningOfProfilingTime := DateAndTime now.
	proxyBasicNew install.
	proxyBasicNewKeyword install
]

{ #category : #accessing }
IllimaniAllocationProfiler >> stats [

	^ AllocationStatistics allocations: profilerHandler objectAllocations
]

{ #category : #evaluating }
IllimaniAllocationProfiler >> stopProfiling [

	proxyBasicNew uninstall.
	proxyBasicNewKeyword uninstall.
	endOfProfilingTime := DateAndTime now
]

{ #category : #accessing }
IllimaniAllocationProfiler >> totalProfiledTime [

	^ endOfProfilingTime - beginningOfProfilingTime
]
