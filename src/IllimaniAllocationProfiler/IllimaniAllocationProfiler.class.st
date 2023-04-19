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
		'statisticsModel',
		'incrementalGCCount',
		'fullGCCount',
		'totalGCTime',
		'proxyArrobas'
	],
	#category : #'IllimaniAllocationProfiler-Profiler'
}

{ #category : #announcements }
IllimaniAllocationProfiler >> announceProfilerStopedProfiling [

	IllimaniAnnouncer uniqueInstance announce: IllimaniStopedProfilingAnnouncement new
]

{ #category : #'accessing - statistics' }
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
	endOfProfilingTime := nil.
	incrementalGCCount := nil.
	fullGCCount := nil.
	totalGCTime := nil
]

{ #category : #api }
IllimaniAllocationProfiler >> copyExecutionStack [

	profilerHandler copyExecutionStack
]

{ #category : #api }
IllimaniAllocationProfiler >> copyObjectIdentityHash [

	profilerHandler copyObjectIdentityHash
]

{ #category : #'accessing - statistics' }
IllimaniAllocationProfiler >> endOfProfilingTime [

	^ endOfProfilingTime
]

{ #category : #api }
IllimaniAllocationProfiler >> forceUninstall [
	"Waring, do not use unless you cannot start the profiler because you have the
	MpCannotInstall exceptionp"

	MpMethodProxy allInstances do: #uninstall
]

{ #category : #'accessing - statistics' }
IllimaniAllocationProfiler >> fullGCCount [

	^ fullGCCount
]

{ #category : #api }
IllimaniAllocationProfiler >> ignoreAllocators: aCollectionOfClasses [

	profilerHandler ignoreAllocators: aCollectionOfClasses
]

{ #category : #'accessing - statistics' }
IllimaniAllocationProfiler >> incrementalGCCount [

	^ incrementalGCCount
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
	proxyBasicNewKeyword := MpMethodProxy onMethod: Behavior >> #basicNew: handler: profilerHandler.
	proxyArrobas := MpMethodProxy onMethod: Number >> #@ handler: profilerHandler.
]

{ #category : #evaluating }
IllimaniAllocationProfiler >> installMethodProxies [

	proxyBasicNew install.
	proxyBasicNewKeyword install.
	proxyArrobas install
]

{ #category : #testing }
IllimaniAllocationProfiler >> isProfilingFinished [

	^ endOfProfilingTime isNotNil
]

{ #category : #testing }
IllimaniAllocationProfiler >> isProfilingStarted [

	^ beginningOfProfilingTime isNotNil
]

{ #category : #api }
IllimaniAllocationProfiler >> keepReferencesToAllocatedObjects [

	profilerHandler keepReferencesToAllocatedObjects
]

{ #category : #accessing }
IllimaniAllocationProfiler >> objectAllocations [

	^ profilerHandler objectAllocations
]

{ #category : #api }
IllimaniAllocationProfiler >> objectsToCapture: aCollectionOfClasses [

	profilerHandler objectsToCapture: aCollectionOfClasses
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
	self installMethodProxies.

	incrementalGCCount := Smalltalk vm incrementalGCCount.
	fullGCCount := Smalltalk vm fullGCCount.
	totalGCTime := Duration milliSeconds: Smalltalk vm totalGCTime
]

{ #category : #'accessing - statistics' }
IllimaniAllocationProfiler >> stats [

	^ statisticsModel
]

{ #category : #evaluating }
IllimaniAllocationProfiler >> stopProfiling [

	self uninstallMethodProxies.
	
	endOfProfilingTime := DateAndTime now.
	incrementalGCCount := Smalltalk vm incrementalGCCount - incrementalGCCount.
	fullGCCount := Smalltalk vm fullGCCount - fullGCCount.
	totalGCTime := (Duration milliSeconds: Smalltalk vm totalGCTime) - totalGCTime.
	statisticsModel := AllocationStatistics new rawAllocations:
		profilerHandler objectAllocations.
		
	self announceProfilerStopedProfiling
]

{ #category : #'accessing - statistics' }
IllimaniAllocationProfiler >> totalGCTime [

	^ totalGCTime
]

{ #category : #'accessing - statistics' }
IllimaniAllocationProfiler >> totalProfiledTime [

	^ endOfProfilingTime - beginningOfProfilingTime
]

{ #category : #evaluating }
IllimaniAllocationProfiler >> uninstallMethodProxies [

	proxyBasicNew uninstall.
	proxyBasicNewKeyword uninstall.
	proxyArrobas uninstall
]
