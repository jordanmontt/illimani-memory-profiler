
# Illimani: a Memory Profiler

[![Pharo version](https://img.shields.io/badge/Pharo-11-%23aac9ff.svg)](https://pharo.org/download)
[![Pharo version](https://img.shields.io/badge/Pharo-10-%23aac9ff.svg)](https://pharo.org/download)

<p align="center">
  <img src="https://cdn.fstoppers.com/styles/full/s3/photos/171592/10/30/1d2b5ac3df32b99cd9a22454527e04ff.jpg" width="500">
</p>

<p align="center">
  <em>The Illimani mountain in La Paz, Bolivia</em>
</p>

## How to install it

```smalltalk
EpMonitor disableDuring: [
	Metacello new
		baseline: 'IllimaniAllocationProfiler';
		repository: 'github://jordanmontt/illimani-memory-profiler:main';
		load ].
```

## Quick Getting Started

Start Playing:

```st
profiler := IllimaniAllocationProfiler new.
profiler
	captureAllObjects;
	profileFor: 5 seconds.
	
profiler open
```

Example 1:

```st
IllimaniAllocationProfiler new
	objectsToCapture: { ByteString . Array . String . OrderedCollection . ByteArray };
	copyExecutionStack;
	profileOn: [ 10000 timesRepeat: [ SpPresenter new ] ];
	open
```

Example 2, capturing all but Morphic

```st
morphicPackages := RPackageOrganizer default packages select: [ :package | package name includesSubstring: 'morphic' caseSensitive: false  ].
morphicClasses := morphicPackages flatCollect: #classes as: Set.

profiler := IllimaniAllocationProfiler new
	captureAllObjects;
	objectsToIgnore: morphicClasses;
	profileFor: 5 seconds;
	yourself.
	
profiler open
```

## Quick Demo

![1](https://github.com/jordanmontt/illimani-memory-profiler/assets/33934979/9eb2cd57-18b2-4303-973b-0861e656bd43)

## How to use it

To use this profiler you need to specify which allocations you want to capture.
For that, you need to set the classes, of the allocations, that you want to capture.
You can capture all object allocations with the message `captureAllObjects` or you can only capture a collection of classes `objectsToCapture: aCollection`.

It is also possible to copy the execution stack of *each* of the allocated objects with the message.
This is very useful when you to make analysis, for example indentify in which context the allocations were prodoced, etc.
Keep in mind that with a lot of allocations, copying the stack can cause the image to grow in size rapidly and making it slow to use.

```st
profiler copyExecutionStack.
```

You can decide both to profile a given method block or just watching the activity of the image for some time.

```st
"With this the profiler will block the ui and you will only capture the objects created by your code snippet"
profiler profileOn: [ anObject performSomeAction ].

"With this the profiler with not block the UI nor the image. So, you will capture all the allocations of the image"
profiler profileFor: 2 seconds.
```

For starting the stoping the profiling manually. This can be useful if you don't know how long your program will run.

```st
profiler startProfiling.
profiler stopProfiling.
```

You can open the ui at any time with the message `open` (even if the profiler is still profiling)

```st
profiler open.
```

If you want to capture all the allocations of objects but ignoring some of them, you can use 

```st
profiler objectsToIgnore: { ByteString . ByteArray }.
```

You can keep the allocated objects. This is useful is for example you want to know how many equal objects did you allocated.
Note that this will affect the GC statistics since the GC will not be able to free memory since the objects are being referencered (!)

```st
profiler keepTheAllocatedObjects.
```

### Sampling

By default, the profiler captures all the object allocations. You can configure it to sample the samples. This can be useful for reducing the overhead when your application makes lots of allocations.

```st
"Capture only 33% of the allocations"
profiler samplingRate: 33.
```

## Statistics

Without the UI, because the profiler is independent from the UI, you can access to some statistics. See the protocol `accessing - statistics` in the profiler to see the methods. Also, the profiler has a statistics model that groups and sorts the allocation by class and by methods. For example check 'profiler stats allocationsByClass.'

![b](https://user-images.githubusercontent.com/33934979/220641933-fb5970d4-532f-4297-873c-f43b7d259c15.gif)
![2](https://github.com/jordanmontt/illimani-memory-profiler/assets/33934979/80a71d78-7deb-494f-9c56-ed32cef29600)

## Implementation

- Illimani uses [method proxies](https://github.com/pharo-contributions/MethodProxies) library to capture the allocations. It insert a proxy in `Behavior>>basicNew:` and `Behavior>>basicNew`.
- Illimani also uses [space and time](https://github.com/tesonep/spaceAndTime) to calculate the total size in memory of an object.
- It has an statistics model that helps with the calculations of allocations grouping them by classes and methods and sorting them by number of allocations. 
- The UI is independent of the profiler. It can be used without it. You will have access to all allocations and to the same statistics.
