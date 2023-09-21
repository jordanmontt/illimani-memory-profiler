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
	#name : 'IllAllocationProfiler',
	#superclass : 'Object',
	#traits : 'IllTAllocatorWrapper',
	#classTraits : 'IllTAllocatorWrapper classTrait',
	#instVars : [
		'profilerHandler',
		'statisticsModel',
		'illimaniAnnouncer'
	],
	#category : 'IllimaniAllocationProfiler-Profiler',
	#package : 'IllimaniAllocationProfiler',
	#tag : 'Profiler'
}

{ #category : 'announcements' }
IllAllocationProfiler >> announceProfilerStopedProfiling [

	illimaniAnnouncer announce: IllStopedProfilingAnnouncement
]

{ #category : 'api' }
IllAllocationProfiler >> captureAllObjects [

	profilerHandler captureAllObjects
]

{ #category : 'api' }
IllAllocationProfiler >> copyExecutionStack [

	profilerHandler copyExecutionStack
]

{ #category : 'api' }
IllAllocationProfiler >> copyObjectIdentityHash [

	profilerHandler copyObjectIdentityHash
]

{ #category : 'initialization' }
IllAllocationProfiler >> initialize [

	super initialize.
	profilerHandler := IllAllocationProfilerMpHandler new.
	illimaniAnnouncer := IllAnnouncer new.
	self initializeMethodProxies: profilerHandler.
]

{ #category : 'api' }
IllAllocationProfiler >> keepReferencesToAllocatedObjects [

	profilerHandler keepReferencesToAllocatedObjects
]

{ #category : 'accessing' }
IllAllocationProfiler >> objectAllocations [

	^ profilerHandler objectAllocations
]

{ #category : 'api' }
IllAllocationProfiler >> objectsToCapture: aCollectionOfClasses [

	profilerHandler objectsToCapture: aCollectionOfClasses
]

{ #category : 'api' }
IllAllocationProfiler >> objectsToIgnore: aCollectionOfClasses [

	profilerHandler objectsToIgnore: aCollectionOfClasses
]

{ #category : 'accessing' }
IllAllocationProfiler >> profilerHandler [

	^ profilerHandler
]

{ #category : 'api' }
IllAllocationProfiler >> samplingRate: anInteger [

	profilerHandler samplingRate: anInteger
]

{ #category : 'accessing - statistics' }
IllAllocationProfiler >> stats [

	^ statisticsModel ifNil: [
		statisticsModel := AllocationStatistics new rawAllocations: profilerHandler objectAllocations.
		statisticsModel ]
]

{ #category : 'evaluating' }
IllAllocationProfiler >> stopProfiling [

	self uninstallMethodProxies.
	self updateStatsWhenFinishingProfiling.
	self announceProfilerStopedProfiling
]
