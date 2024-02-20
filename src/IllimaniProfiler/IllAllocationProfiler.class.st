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
	#name : 'IllAllocationProfiler',
	#superclass : 'IllAbstractProfiler',
	#instVars : [
		'statisticsModel',
		'illimaniAnnouncer',
		'copyExecutionStack',
		'classesToAvoidInTheContextSearch',
		'objectAllocations'
	],
	#category : 'IllimaniProfiler-Allocation-Profiler',
	#package : 'IllimaniProfiler',
	#tag : 'Allocation-Profiler'
}

{ #category : 'announcements' }
IllAllocationProfiler >> announceProfilerStopedProfiling [

	illimaniAnnouncer announce: IllStopedProfilingAnnouncement
]

{ #category : 'api' }
IllAllocationProfiler >> copyExecutionStack [
	"When this is set to true, for each object allocationn the full execution stack from which
	the method was created will be copied and store. This information will be available for
	making analysis. Keep in mind that when there is a lot of allocations going the size of
	the image can grow quickly and drastically."

	copyExecutionStack := true
]

{ #category : 'initialization' }
IllAllocationProfiler >> defaultClassesToAvoidInTheContextSearch [

	^ {
		  "Process."
		  IllAllocationProfiler.
		  IllAbstractProfiler.
		  IllMpHandler.
		  "MpMethodProxy."
		  "BlockClosure."
		  "FullBlockClosure"
		  "CompiledBlock" }
]

{ #category : 'api' }
IllAllocationProfiler >> doNotCopyExecutionStack [
	"See the comment of my opposite method"

	copyExecutionStack := false
]

{ #category : 'exporting' }
IllAllocationProfiler >> exporterClass [

	^ IllAllocationSiteExporter
]

{ #category : 'evaluating' }
IllAllocationProfiler >> filterContext: aContext ignoringClass: aClass [

	| sender |
	sender := aContext sender.
	[
	sender receiver class = aClass or: [
		sender receiver class = aClass class or: [
			classesToAvoidInTheContextSearch includes: sender receiver class ] ] ]
		whileTrue: [ sender := sender sender ].
	^ sender
]

{ #category : 'accessing' }
IllAllocationProfiler >> illimaniAnnouncer [

	^ illimaniAnnouncer
]

{ #category : 'initialization' }
IllAllocationProfiler >> initialize [

	super initialize.
	illimaniAnnouncer := IllAnnouncer new.
	objectAllocations := OrderedCollection new.
	copyExecutionStack := false.
	classesToAvoidInTheContextSearch := self defaultClassesToAvoidInTheContextSearch
	  , (self defaultClassesToAvoidInTheContextSearch collect: [ :aClass | aClass class ])
]

{ #category : 'profiling' }
IllAllocationProfiler >> internalRegisterAllocation: newlyAllocatedObject [

	| filteredContext  allocationInformationHolder |

	allocationInformationHolder := AllocationSiteInfoModel new.
	filteredContext := self filterContext: thisContext ignoringClass: newlyAllocatedObject class.

	copyExecutionStack ifTrue: [ allocationInformationHolder context: filteredContext copyStack ].

	allocationInformationHolder
		allocatorClass: filteredContext receiver class;
		allocatorMethod: filteredContext compiledCode method;
		allocatedObjectClass: newlyAllocatedObject class;
		"contextFingerprint: filteredContext;"
		sizeInBytes: newlyAllocatedObject sizeInMemory;
		initializationTime: Time primUTCMicrosecondsClock.

	objectAllocations add: allocationInformationHolder
]

{ #category : 'accessing' }
IllAllocationProfiler >> objectAllocations [

	^ objectAllocations
]

{ #category : 'accessing - statistics' }
IllAllocationProfiler >> stats [

	^ statisticsModel ifNil: [
		  statisticsModel := AllocationsStatsModel new rawAllocations: objectAllocations ]
]

{ #category : 'profiling' }
IllAllocationProfiler >> stopProfiling [

	super stopProfiling.
	self announceProfilerStopedProfiling
]
