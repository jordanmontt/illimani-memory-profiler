# Illimani: a Memory Profiler

<p align="center">
  <img src="https://cdn.fstoppers.com/styles/full/s3/photos/171592/10/30/1d2b5ac3df32b99cd9a22454527e04ff.jpg" width="500">
</p>

<p align="center">
  <em>The Illimani mountain in La Paz, Bolivia</em>
</p>

## How to install it

```st
Metacello new
  baseline: 'AllocationProfiler';
  repository: 'github://jordanmontt/illimani-memory-profiler:main';
  load.
```

## Quick Getting Started

Example 1:

```st
IllimaniAllocationProfiler new
	classesToCapture: { Color };
	profileFor: 3 seconds;
	open
```

Example 2:

```st
IllimaniAllocationProfiler new
	captureAllObjects;
	copyExecutionStack;
	profileOn: [ 1000 timesRepeat: [ SpPresenter new ] ];
	open
```

## How to use it

To use this tool you need to set the classes that you want to capture or indicate that you want to capture all objects. You can do that with the messages `classesToCapture: aCollection` or `captureAllObjects`. It is also possible to copy the execution stack of *each* of the allocated objects with the message `copyExecutionStack`. Keep in mind that it there is a lot of allocations going on copying the stack can cause the image to grow rapidly and making the image slow.

You can decide both to profile a given method block or just watching the activity of the image for some time.

```st
profiler profileOn: [ anObject performSomeAction ].

profiler profileFor: 2 seconds
```

You can open the ui at any time with the message `open`

```
profiler open
```

## Implementation

Illimani relies on [method proxies](https://github.com/pharo-contributions/MethodProxies) library to capture the allocations. It is a top layer of method proxies that eases the use for the allocation capturing. The UI is completly independent of the profiler. It can be used without it. You will have access to all allocations and to the same statistics.

This is a prototype version

Observations:

- I have see that for a lot of allocations the statistics and the roassal presenters take a lot of time to be calculated. It is need to improve this. But it is not blocking for releasing a first version.
- When capturing all the object I saw that the class `Behavior` is by far the one that allocates the most objects. Do we need to take into account the sender instead?
