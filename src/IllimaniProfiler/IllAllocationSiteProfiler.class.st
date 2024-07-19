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
	#name : 'IllAllocationSiteProfiler',
	#superclass : 'IllAbstractProfiler',
	#instVars : [
		'statisticsModel',
		'copyExecutionStack',
		'classesToAvoidInTheContextSearch',
		'objectAllocations'
	],
	#category : 'IllimaniProfiler-Allocation-Profiler',
	#package : 'IllimaniProfiler',
	#tag : 'Allocation-Profiler'
}

{ #category : 'accessing - statistics' }
IllAllocationSiteProfiler >> allocationsStats [

	^ statisticsModel ifNil: [
		  statisticsModel := AllocationsStatsModel new rawAllocations: objectAllocations ]
]

{ #category : 'initialization' }
IllAllocationSiteProfiler >> defaultClassesToAvoidInTheContextSearch [

	^ {
		  "Process."
		  IllAllocationSiteProfiler.
		  IllAbstractProfiler.
		  IllHandler.
		  "MpMethodProxy."
		  "BlockClosure."
		  "FullBlockClosure"
		  "CompiledBlock" }
]

{ #category : 'exporting' }
IllAllocationSiteProfiler >> exporterClass [

	^ IllAllocationSiteExporter
]

{ #category : 'initialization' }
IllAllocationSiteProfiler >> initialize [

	super initialize.
	objectAllocations := OrderedCollection new.
	copyExecutionStack := false.
	classesToAvoidInTheContextSearch := self defaultClassesToAvoidInTheContextSearch
]

{ #category : 'profiling' }
IllAllocationSiteProfiler >> internalRegisterAllocation: newlyAllocatedObject [

	| filteredContext  allocationInformationHolder allocatedObjectClass |

	allocationInformationHolder := AllocationSiteInfoModel new.
	allocatedObjectClass := newlyAllocatedObject class.
	
	filteredContext := thisContext.
	[
	filteredContext receiver class = allocatedObjectClass class or: [
		classesToAvoidInTheContextSearch includes: filteredContext receiver class ] ]
		whileTrue: [ filteredContext := filteredContext sender ].

	allocationInformationHolder
		allocatorMethod: filteredContext homeMethod;
		allocatedObjectClass: allocatedObjectClass;
		contextFingerprint: filteredContext;
		sizeInBytes: newlyAllocatedObject sizeInMemory.

	objectAllocations add: allocationInformationHolder
]

{ #category : 'accessing' }
IllAllocationSiteProfiler >> objectAllocations [

	^ objectAllocations
]
