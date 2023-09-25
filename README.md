
# Illimani: a Memory Profiler

[![Pharo version](https://img.shields.io/badge/Pharo-12-%23aac9ff.svg)](https://pharo.org/download)
[![Pharo version](https://img.shields.io/badge/Pharo-11-%23aac9ff.svg)](https://pharo.org/download)
[![Pharo version](https://img.shields.io/badge/Pharo-10-%23aac9ff.svg)](https://pharo.org/download)

<p align="center">
  <img src="https://cdn.fstoppers.com/styles/full/s3/photos/171592/10/30/1d2b5ac3df32b99cd9a22454527e04ff.jpg" width="500">
</p>

<p align="center">
  <em>The Illimani mountain in La Paz, Bolivia</em>
</p>

The release version works on Pharo 10, 11 and Pharo 12. But, keep in mind that the profiler should be faster in Pharo 12. This is because there were some optimizations done in Pharo 12 to make the instrumentation faster.

## How to install it

```smalltalk
EpMonitor disableDuring: [
	Metacello new
		baseline: 'IllimaniProfiler';
		repository: 'github://jordanmontt/illimani-memory-profiler:main';
		load ].
```

## Quick Getting Started

Start Playing:

```st
profiler := IllAllocationProfiler new.
profiler
	profileFor: 5 seconds.
	
profiler open
```

Example 1:

```st
IllAllocationProfiler new
	copyExecutionStack;
	profileOn: [ 1000 timesRepeat: [ SpPresenter new ] ];
	open
```

Example 2, capturing all while interacting with the Pharo IDE

```st

profiler := IllAllocationProfiler new
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

### Sampling

By default, the profiler captures all the object allocations. You can configure it to sample the samples. This can be useful for reducing the overhead when your application makes lots of allocations.

```st
"Capture only 33% of the allocations"
profiler samplingRate: 33.
```

## Statistics

Without the UI, because the profiler is independent from the UI, you can access to some statistics. See the protocol `accessing - statistics` in the profiler to see the methods. Also, the profiler has a statistics model that groups and sorts the allocation by class and by methods. For example check 'profiler stats allocationsByClass.'

![2](https://github.com/jordanmontt/illimani-memory-profiler/assets/33934979/80a71d78-7deb-494f-9c56-ed32cef29600)

## Implementation

- Illimani uses [method proxies](https://github.com/pharo-contributions/MethodProxies) library to capture the allocations. It insert a proxy in `Behavior>>basicNew:` and `Behavior>>basicNew`.
- It has an statistics model that helps with the calculations of allocations grouping them by classes and methods and sorting them by number of allocations. 
- The UI is independent of the profiler. It can be used without it. You will have access to all allocations and to the same statistics.
