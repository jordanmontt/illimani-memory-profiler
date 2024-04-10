"
I am a Memory Allocation Sites Profiler. I provide information about the allocation sites of the allocated objects of your application. Information such as who is the allocator class, allocator method, the context in where the allocation was made, etc.

I will ìnstall method proxies inside some allocator methods to capture the allocations

```
profiler :=  IllimaniAllocationProfiler new.	
```

To profile a code block:

```
profiler profileOn: [ anObject performSomeAction ]
```

To monitor the image for a given duration a code block:

```
profiler profileFor: 5 seconds
```

You can open the ui at any time with the message `open`, even if the profiling is still being made.

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
IllAllocationProfiler new
	profileFor: 3 seconds;
	open.
```

Example 2:

```
IllAllocationProfiler new
	copyExecutionStack;
	profileOn: [ 1000 timesRepeat: [ Object new ] ];
	open
```
"
Class {
	#name : 'IllFullMemoryProfiler',
	#superclass : 'IllAbstractProfiler',
	#instVars : [
		'statisticsModel',
		'illimaniAnnouncer',
		'classesToAvoidInTheContextSearch',
		'objectAllocations'
	],
	#category : 'IllimaniProfiler-Allocation-Profiler',
	#package : 'IllimaniProfiler',
	#tag : 'Allocation-Profiler'
}

{ #category : 'announcements' }
IllFullMemoryProfiler >> announceProfilerStopedProfiling [

	illimaniAnnouncer announce: IllStopedProfilingAnnouncement
]

{ #category : 'initialization' }
IllFullMemoryProfiler >> defaultClassesToAvoidInTheContextSearch [

	^ {
		  "Process."
		  self class.
		  IllAbstractProfiler.
		  IllHandler.
		  "MpMethodProxy."
		  "BlockClosure."
		  "FullBlockClosure"
		  "CompiledBlock" }
]

{ #category : 'exporting' }
IllFullMemoryProfiler >> exporterClass [

	self flag: 'change exporter'.
	^ IllAllocationSiteExporter
]

{ #category : 'evaluating' }
IllFullMemoryProfiler >> filterContext: aContext ignoringClass: aClass [

	| sender |
	sender := aContext sender.
	[
	sender receiver class = aClass or: [
		sender receiver class = aClass class or: [
			classesToAvoidInTheContextSearch includes: sender receiver class ] ] ]
		whileTrue: [ sender := sender sender ].
	^ sender
]

{ #category : 'accessing - statistics' }
IllFullMemoryProfiler >> forceFinalizationOfObjects [

	objectAllocations do: [ :e | e forceFinalization ]
]

{ #category : 'accessing' }
IllFullMemoryProfiler >> illimaniAnnouncer [

	^ illimaniAnnouncer
]

{ #category : 'initialization' }
IllFullMemoryProfiler >> initialize [

	super initialize.
	illimaniAnnouncer := IllAnnouncer new.
	objectAllocations := OrderedCollection new: 100000000.
	classesToAvoidInTheContextSearch := self defaultClassesToAvoidInTheContextSearch
	  , (self defaultClassesToAvoidInTheContextSearch collect: [ :aClass | aClass class ])
]

{ #category : 'profiling' }
IllFullMemoryProfiler >> internalRegisterAllocation: newlyAllocatedObject [

	| filteredContext  allocationSiteEphemeron |

	filteredContext := self filterContext: thisContext ignoringClass: newlyAllocatedObject class.
	allocationSiteEphemeron := IllEphemeronAllocationSite new
		key: newlyAllocatedObject value: nil;
		allocatorClass: filteredContext receiver class;
		allocatorMethod: filteredContext compiledCode method;
		yourself.

	objectAllocations add: allocationSiteEphemeron
]

{ #category : 'accessing' }
IllFullMemoryProfiler >> objectAllocations [

	^ objectAllocations
]

{ #category : 'accessing - statistics' }
IllFullMemoryProfiler >> stats [

	self flag: 'Need to change this'.
	self notYetImplemented.
	^ statisticsModel ifNil: [
		  statisticsModel := AllocationsStatsModel new rawAllocations: objectAllocations ]
]

{ #category : 'profiling' }
IllFullMemoryProfiler >> stopProfiling [

	super stopProfiling.
	self forceFinalizationOfObjects.
	self announceProfilerStopedProfiling
]
