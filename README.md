
# Illimani: a Memory Profiler

[![Pharo version](https://img.shields.io/badge/Pharo-13-%23aac9ff.svg)](https://pharo.org/download)


Illimani is a library of memory profilers. It provides an - allocation site memory profiler, - a object lifetimes profiler, - and an allocation rate profiler. The allocation site profiler gives you information about the allocation sites and where the objects where produced in your application. The object lifetimes profiler gives you information about how much time did the objects lived, and about how many GC cycles (both scavenges and full GC) they survived.

## How to install it

```smalltalk
EpMonitor disableDuring: [
	Metacello new
		baseline: 'IllimaniProfiler';
		repository: 'github://jordanmontt/illimani-memory-profiler:main';
		load ].
```

## Quick Getting Started

Profiling a given code snippet

```st
profiler
	profileOn: [ 15 timesRepeat: [ StPlaygroundPresenter open close ] ] ;
	open;
	yourself
```

Profiling the Pharo IDE activity for a given amount of time

```st
profiler
	profileFor: 6 seconds;
	open;
	yourself
```

Example 1, allocation profiler for profiling the Pharo IDE activity

```st
IllAllocationSiteProfiler new
	copyExecutionStack;
	profileFor: 6 seconds;
	open;
	yourself
```

Example 2, object lifetimes profiler on a code snippet:

```st
IllObjectLifetimesProfiler new
	profileOn: [ 15 timesRepeat: [ StPlaygroundPresenter open close ] ] ;
	open;
	yourself
```

## How to use

### Profile a code snippet or the Pharo IDE

You can decide both to profile a given method block or just watching the activity of the image for some time.

```st
"With this the profiler will block the ui and you will only capture the objects created by your code snippet"
profiler profileOn: [ anObject performSomeAction ].

"With this the profiler with not block the UI nor the image. So, you will capture all the allocations of the image"
profiler profileFor: 2 seconds.
```

### Profiler manual API

For starting the stoping the profiling manually. This can be useful if you don't know how long your program will run and you need to interact with the Pharo's IDE.

```st
profiler startProfiling.
profiler stopProfiling.
```

### Open the GUI

You can open the ui at any time with the message `open` (even if the profiler is still profiling)

```st
profiler open.
```

### Sample the allocations

By default, the profiler captures 1% of the allocations. We chose this number because in our experiments we found out that the profiler producess precise results with minimal overhead with that sampling rate. You can change the sampling rate. The sampling rate needs to be a fraction.

```st
"Capture 10% of the allocations"
profiler samplingRate: 1/10.

"Capture 100% of the allocations"
profiler samplingRate: 1.
```

### Export the profiled data to files

You can export the data to csv and json files by doing:

```st
profiler exportData
```

This will create a csv file with all the information about the allocated objects, and some other auxiliary files in json and csv. This auxiliary files can be the meta data about the total profiled time, the gc activity, etc.

### Monitor the GC activity

You can monitor the GC activity while the profiler is profiling with the message `monitorGCActivity`. This will fork a process that will take GC statistics once per second. Then, when exporting the profiler data, two csv files will be exported containing both the scavenges and full GCs. By default, the GC monitoring is disabled.

```st
profiler monitorGCActivity
```

## Implement your own memory profiler

Illimani is also a profiling framework. A user can implement his own profiler by subclassing the `IllAbstractProfiler` class and defining the few missing methods. Especially, the `internalRegisterAllocation:` method. The `internalRegisterAllocation:` method will be called each time that an allocation is produced (or when sampling, each time that the sampling rates matches) with the newly allocated object as a parameter. You can the `IllAllocationRateProfiler` class as an example of a very simple memory profiler.

## Allocation Site profiler

![allo](https://github.com/jordanmontt/illimani-memory-profiler/assets/33934979/c83ab37b-3ec3-4f19-b4de-02110cd837af)

Without the UI, because the profiler is independent from the UI, you can access to some statistics. See the protocol `accessing - statistics` in the profiler to see the methods. Also, the profiler has a statistics model that groups and sorts the allocation by class and by methods. For example check 'profiler stats allocationsByClass.'

## Object lifetimes profiler

![fina](https://github.com/jordanmontt/illimani-memory-profiler/assets/33934979/e0c3cf6e-5105-45dc-84ba-26a5513a6710)

## Related papers

 - [ILLIMANI Memory Profiler - A Technical Report. Jordan Montaño S., Polito G., Ducasse S., Tesone P. 2023. Technical Report.](https://hal.science/hal-04225251/file/conference_101719.pdf)
 - [Evaluating Finalization-Based Object Lifetime Profiling. Jordan Montaño S., Polito G., Ducasse S., Tesone P., 2024, ISMM.](https://hal.science/hal-04581342v1/document)

## Implementation details

- Illimani uses [method proxies](https://github.com/pharo-contributions/MethodProxies) library to capture the allocations. It instruments all the allocator methods in Pharo.
- The object lifetimes profiler uses Ephemerons to know when an object is about to be finalized. 
- It has an statistics model that helps with the calculations of allocations grouping them by classes and methods and sorting them by number of allocations. 
- The UI is independent of the profiler. It can be used without it. You will have access to all allocations and to the same statistics.
