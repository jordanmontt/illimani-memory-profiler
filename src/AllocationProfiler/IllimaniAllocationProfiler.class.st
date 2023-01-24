"
I am a Memory Profiler.

I will put a proxy method  inside the methods: `basicNew` and `basicNew:` of the Behavior class.
First, you need to specify which classes do you want to capture. For example, let's say that you can to register the allocations of Color objects:

```
profiler :=  IllimaniAllocationProfiler new.
profiler classesToRegister: { Color }.
```

Or if you want to capture all type of objects

```
profiler captureAllObjects
```

To profile a code block:

```
profiler profileOn: [ anObject performSomeAction ]
```

To monitor the image for a given duration a code block:

```
profiler profileFor: 2 seconds
```

You can open the ui at any time with the message `open`

```
profiler open
```

You can configure to copy the execution stack

```
profiler copyExecutionStack
```

Keep in mind that your image can get slow and big. The Pharo image allocate thousands, even houndreads of thousands, of objects per minute.

Example 1:

```
IllimaniAllocationProfiler new
	copyExecutionStack
	classesToRegister: { Rectangle };
	profileFor: 3 seconds;
	open.
```

Example 2:

```
IllimaniAllocationProfiler new
	captureAllObjects;
	copyExecutionStack;
	profileOn: [ 1000 timesRepeat: [ Object new ] ];
	open
```
"
Class {
	#name : #IllimaniAllocationProfiler,
	#superclass : #Object,
	#instVars : [
		'proxyBasicNew',
		'proxyBasicNewKeyword',
		'profilerHandler',
		'beginningOfProfilingTime',
		'endOfProfilingTime',
		'statisticsModel'
	],
	#category : #AllocationProfiler
}

{ #category : #api }
IllimaniAllocationProfiler class >> profileFor: aDuration [

	| profiler |
	profiler := self new.
	[ profiler profileFor: aDuration ] fork.
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

{ #category : #api }
IllimaniAllocationProfiler >> classesToRegister: aCollection [

	profilerHandler classesToRegister: aCollection
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
	self initializeStatisticsModel.
	self initializeMethodProxies
]

{ #category : #evaluating }
IllimaniAllocationProfiler >> initializeMethodProxies [

	proxyBasicNew := MpMethodProxy onMethod: Behavior >> #basicNew handler: profilerHandler.
	proxyBasicNewKeyword := MpMethodProxy onMethod: Behavior >> #basicNew: handler: profilerHandler
]

{ #category : #initialization }
IllimaniAllocationProfiler >> initializeStatisticsModel [

	statisticsModel := AllocationStatistics allocations: profilerHandler objectAllocations
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
IllimaniAllocationProfiler >> profileFor: aDuration [
	"Done with a fork because we don't want to block the ui thread since it allocates objects. "

	self startProfiling.
	[
	(Delay forDuration: aDuration) wait.
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

	^ statisticsModel
]

{ #category : #evaluating }
IllimaniAllocationProfiler >> stopProfiling [

	proxyBasicNew uninstall.
	proxyBasicNewKeyword uninstall.
	endOfProfilingTime := DateAndTime now.
	self initializeStatisticsModel
]

{ #category : #accessing }
IllimaniAllocationProfiler >> totalProfiledTime [

	^ endOfProfilingTime - beginningOfProfilingTime
]
