# Illimani: a memory profiler framework for Pharo

[![Pharo version](https://img.shields.io/badge/Pharo-12-%23aac9ff.svg)](https://pharo.org/download)[![Pharo version](https://img.shields.io/badge/Pharo-13-%23aac9ff.svg)](https://pharo.org/download)[![Pharo version](https://img.shields.io/badge/Pharo-14-%23aac9ff.svg)](https://pharo.org/download)

Illimani is a framework for crafting custom memory profilers in Pharo. It instruments and captures **all object allocations** during the execution of an application, providing a solid infrastructure on which to build your own profiler.

It uses [MethodProxies](https://github.com/pharo-contributions/MethodProxies) as its instrumentation backend and instruments **all 14 allocator methods present in Pharo**. By subclassing a class and overriding a few methods, you can implement your own memory profiler.

Illimani ships with several profiler implementations:

- **Allocation rate profiler** — counts allocations and their size in memory.
- **Allocation call graph** — records the call stacks that led to object allocations.
- **Object lifetime profiler (FiLiP)** — estimates the lifetime of each allocated object.

## About FiLiP

FiLiP (**Fi**nalization **Li**fetime **P**rofiler) estimates the lifetime of each allocated object. It records the object's **birth time** at allocation (via MethodProxies instrumentation) and its **death time** using finalization, a virtual machine mechanism that runs an action when an object is about to be garbage collected. It also registers the stack trace, memory size, and type of each allocation, enabling the construction of an allocation call graph and a wider picture of the application's memory profile.

FiLiP includes **sampling support** to reduce memory overhead. We evaluated the precision of the sampling rate in [this paper](https://hal.science/hal-04581342v1/document) and obtained good results even at a 1% sampling rate. By default FiLiP uses a 1% sampling rate, but it is configurable.

FiLiP has a full GUI for examining profile information, plus a statistics object model that can be queried programmatically for powerful memory analysis.

## How to install

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

## Quick start

Profile a code snippet:

```st
FiLiP new
	profileOn: [ 15 timesRepeat: [ StPlaygroundPresenter open close ] ] ;
	open;
	yourself
```

Profile a code snippet and cut the execution after a given amount of time:

```st
FiLiP new
	profileOnBlock: aBlock forDuration: 6 seconds;
	open;
	yourself
```

Profile the Pharo IDE activity for a given amount of time:

```st
FiLiP new
	profileFor: 6 seconds;
	open;
	yourself
```

## How to use

### Profile a code snippet or the Pharo IDE

```st
profiler := FiLiP new.
"Blocks the UI; captures only the objects created by your code snippet"
profiler profileOn: [ anObject performSomeAction ].

"Does not block the UI; captures all allocations of the image"
profiler profileFor: 2 seconds.
```

### Manual API

Start and stop profiling manually, useful when you don't know how long your program will run:

```st
profiler startProfiling.
profiler stopProfiling.
```

### Open the GUI

You can open the UI at any time with `open`, even while profiling:

```st
profiler open.
```

### Sample the allocations

By default the profiler captures 1% of allocations. The sampling rate must be a fraction:

```st
"Capture 10% of the allocations"
profiler samplingRate: 1/10.

"Capture 100% of the allocations"
profiler samplingRate: 1.
```

### Export the profiled data

Export the data to csv and json files:

```st
profiler exportData
```

This creates a csv file with all the information about the allocated objects, plus auxiliary files (json/csv) with metadata such as total profiled time and GC activity.

### Monitor the GC activity

Fork a process that samples GC statistics once per second. When exporting, two csv files are produced (scavenges and full GCs). Disabled by default:

```st
profiler monitorGCActivity
```

## Implement your own memory profiler

Subclass `IllAbstractProfiler` and define the missing methods, especially `internalRegisterAllocation:`. This method is called each time an allocation is produced (or when sampling matches) with the newly allocated object as parameter. See `IllAllocationRateProfiler` as a simple example.

## Statistics

Without the UI, you can access statistics programmatically. See the `accessing - statistics` protocol on the profiler, plus a statistics model that groups and sorts allocations by class and by method.

## A glance at the UI

<img width="949" alt="image" src="https://github.com/user-attachments/assets/e8bbc116-33ae-4e7e-abe7-58fb7a253366">

## Related papers

- [ILLIMANI Memory Profiler - A Technical Report. Jordan Montaño S., Polito G., Ducasse S., Tesone P. 2023. Technical Report.](https://hal.science/hal-04225251/file/conference_101719.pdf)
- [Evaluating Finalization-Based Object Lifetime Profiling. Jordan Montaño S., Polito G., Ducasse S., Tesone P., 2024, ISMM.](https://hal.science/hal-04581342v1/document)

## Implementation details

- Illimani uses [MethodProxies](https://github.com/pharo-contributions/MethodProxies) to capture allocations, instrumenting all allocator methods in Pharo.
- The object lifetime profiler uses Ephemerons to know when an object is about to be finalized.
- It has a statistics model that groups allocations by class and method, sorted by number of allocations.
- The UI is independent of the profiler and can be used without it.