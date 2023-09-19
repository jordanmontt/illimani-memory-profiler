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
	#name : 'IllimaniAllocationProfiler',
	#superclass : 'Object',
	#traits : 'IllimaniTAllocatorWrapper',
	#classTraits : 'IllimaniTAllocatorWrapper classTrait',
	#instVars : [
		'profilerHandler',
		'statisticsModel',
		'illimaniAnnouncer'
	],
	#category : 'IllimaniAllocationProfiler-Core',
	#package : 'IllimaniAllocationProfiler',
	#tag : 'Core'
}

{ #category : 'announcements' }
IllimaniAllocationProfiler >> announceProfilerStopedProfiling [

	illimaniAnnouncer announce: IllimaniStopedProfilingAnnouncement
]

{ #category : 'api' }
IllimaniAllocationProfiler >> captureAllObjects [

	profilerHandler captureAllObjects
]

{ #category : 'evaluating' }
IllimaniAllocationProfiler >> cleanProfilingData [

	profilerHandler cleanObjectAllocations
]

{ #category : 'api' }
IllimaniAllocationProfiler >> copyExecutionStack [

	profilerHandler copyExecutionStack
]

{ #category : 'api' }
IllimaniAllocationProfiler >> copyObjectIdentityHash [

	profilerHandler copyObjectIdentityHash
]

{ #category : 'initialization' }
IllimaniAllocationProfiler >> initialize [

	super initialize.
	profilerHandler := IllimaniProfilerMpHandler new.
	illimaniAnnouncer := IllimaniAnnouncer new.
	self initializeMethodProxies: profilerHandler.
]

{ #category : 'api' }
IllimaniAllocationProfiler >> keepReferencesToAllocatedObjects [

	profilerHandler keepReferencesToAllocatedObjects
]

{ #category : 'accessing' }
IllimaniAllocationProfiler >> objectAllocations [

	^ profilerHandler objectAllocations
]

{ #category : 'api' }
IllimaniAllocationProfiler >> objectsToCapture: aCollectionOfClasses [

	profilerHandler objectsToCapture: aCollectionOfClasses
]

{ #category : 'api' }
IllimaniAllocationProfiler >> objectsToIgnore: aCollectionOfClasses [

	profilerHandler objectsToIgnore: aCollectionOfClasses
]

{ #category : 'accessing' }
IllimaniAllocationProfiler >> profilerHandler [

	^ profilerHandler
]

{ #category : 'api' }
IllimaniAllocationProfiler >> samplingRate: anInteger [

	profilerHandler samplingRate: anInteger
]

{ #category : 'evaluating' }
IllimaniAllocationProfiler >> startProfiling [

	self cleanProfilingData.
	self installMethodProxies.

	self initializeProfilingBasicStats
]

{ #category : 'accessing - statistics' }
IllimaniAllocationProfiler >> stats [

	^ statisticsModel
]

{ #category : 'evaluating' }
IllimaniAllocationProfiler >> stopProfiling [

	self uninstallMethodProxies.
	self updateStatsWhenFinishingProfiling.
	statisticsModel := AllocationStatistics new
		rawAllocations: profilerHandler objectAllocations;
		yourself.
	self announceProfilerStopedProfiling
]
