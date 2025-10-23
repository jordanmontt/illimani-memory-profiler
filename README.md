
# Illimani: a memory profiler framework with different profilers implemented

[![Pharo version](https://img.shields.io/badge/Pharo-12-%23aac9ff.svg)](https://pharo.org/download)[![Pharo version](https://img.shields.io/badge/Pharo-13-%23aac9ff.svg)](https://pharo.org/download)[![Pharo version](https://img.shields.io/badge/Pharo-14-%23aac9ff.svg)](https://pharo.org/download)

Illimani is a framework for crafting custom memory profilers. It provides a solid infrastructure that instruments and captures all object allocations during the execution of an application.
It uses [MethodProxies](https://github.com/pharo-contributions/MethodProxies) as its instrumentation backend, and **it instruments all the 14 allocator methods present in Pharo**. By subclassing a class and overriding a few methods, users can implement their own memory profiler.

The framework Illimani provides different profiler implementations. It implements an allocation rate profiler that counts the number of allocation and their size in memory; an allocation call graph that registers the call stacks that led to object allocations; and an object lifetime profiler. Illimani uses one instrumentation handler (the after method in this case, we register the actions after it is made) to always forward the logic to the profiler. This is an implementation decision to keep the profiler logic in the profiler and not in the instrumentation handler. This decision is key to keep the instrumentation backend independent from the profiler logic, allowing users to use different instrumentation backends if wanted.

## About FiLiP

FiLiP is an object lifeteime profiler: it estimate the lifetime for each allocated object. FiLiP also registers the stack trace for each object allocation, allowing for the construction of an allocation call graph and better understanding allocation patterns. It also records the memory size, type, and other relevant information for each object allocation to give a wider picture of the memory profile of the application.

We have used FiLiP (**Fi**nalization **Li**fetime **P**rofiler), in several experiments, and to profile industrial applications with memory problems. FiLiP has proved to be useful in identifying the causes of the memory problems. Using finalization, a mechanism provided by the virtual machine to execute an action when an object is about to be garbage collected, we record the object's death time. The birth time is obtained thanks to the MethodProxies instrumentation, as it captures the allocation immediately after it is made. With this information, FiLiP is capable of estimating object lifetimes.

FiLiP includes sampling support to reduce memory overhead. We have evaluated the precision of the sampling rate in [this paper](https://hal.science/hal-04581342v1/document), and we obtained good results even with a sampling rate of 1%. By default, FiLiP uses a sampling rate of 1%, but it is customizable. This configuration can significantly reduce the overhead.

FiLiP has a full GUI from which all general information of the profile can be examined. It also has a statistics object model that users can programatically query to obtain all sorts of information. Thanks to these capabilities, users can perform powerful memory analysis to apply memory optimizations.

## How to install it

Latest version
```smalltalk
EpMonitor disableDuring: [
	Metacello new
		baseline: 'IllimaniProfiler';
		repository: 'github://jordanmontt/illimani-memory-profiler:dev';
		load ].
```

Stable version
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
FiLiP new
	profileOn: [ 15 timesRepeat: [ StPlaygroundPresenter open close ] ] ;
	open;
	yourself
```

Profiling the Pharo IDE activity for a given amount of time

```st
FiLiP new
	profileFor: 6 seconds;
	open;
	yourself
```

Example 1, Profiling the Pharo IDE activity

```st
FiLiP new
	copyExecutionStack;
	profileFor: 6 seconds;
	open;
	yourself
```

Example 2, Profiling on a code snippet:

```st
FiLiP new
	profileOn: [ 15 timesRepeat: [ StPlaygroundPresenter open close ] ] ;
	open;
	yourself
```

## How to use

### Profile a code snippet or the Pharo IDE

You can decide both to profile a given method block or just watching the activity of the image for some time.

```st
profiler := FiLiP new.
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

By default, the profiler captures 1% of the allocations. We chose this number because in our experiments we found out that the profiler producess precise results with minimal overhead with that sampling rate. You can change the sampling rate. Attention, the sampling rate needs to be a fraction.

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

You can monitor the GC activity while the profiler is profiling with the message `monitorGCActivity`. This will fork a process that will take GC statistics once per second. Then, when exporting the profiler data, two csv files will be exported containing both the scavenges and full GCs. By default, the GC monitoring is disabled. You can enable the GC monitor with the message:

```st
profiler monitorGCActivity
```

## Implement your own memory profiler

Illimani is also a profiling framework. A user can implement his own profiler by subclassing the `IllAbstractProfiler` class and defining the few missing methods. Especially, the `internalRegisterAllocation:` method. The `internalRegisterAllocation:` method will be called each time that an allocation is produced (or when sampling, each time that the sampling rates matches) with the newly allocated object as a parameter. You can the `IllAllocationRateProfiler` class as an example of a simple memory profiler.

## Statistics

Without the UI, because the profiler is independent from the UI, you can access to some statistics. See the protocol `accessing - statistics` in the profiler to see the methods. Also, the profiler has a statistics model that groups and sorts the allocation by class and by methods.

## A glance at the UI

<img width="949" alt="image" src="https://github.com/user-attachments/assets/e8bbc116-33ae-4e7e-abe7-58fb7a253366">

## Related papers

 - [ILLIMANI Memory Profiler - A Technical Report. Jordan Montaño S., Polito G., Ducasse S., Tesone P. 2023. Technical Report.](https://hal.science/hal-04225251/file/conference_101719.pdf)
 - [Evaluating Finalization-Based Object Lifetime Profiling. Jordan Montaño S., Polito G., Ducasse S., Tesone P., 2024, ISMM.](https://hal.science/hal-04581342v1/document)

## Implementation details

- Illimani uses [method proxies](https://github.com/pharo-contributions/MethodProxies) library to capture the allocations. It instruments all the allocator methods in Pharo.
- The object lifetimes profiler uses Ephemerons to know when an object is about to be finalized. 
- It has an statistics model that helps with the calculations of allocations grouping them by classes and methods and sorting them by number of allocations. 
- The UI is independent of the profiler. It can be used without it. You will have access to all allocations and to the same statistics.
