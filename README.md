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

## How to use it

Open the tool with the message `IllimaniAllocatorProfiler open`.

![](https://i.imgur.com/6uzowKd.gif)

## Implementation

Illimani relies on [method proxies](https://github.com/pharo-contributions/MethodProxies) library to capture the allocations. It is a top layer of method proxies that eases the use for the allocation capturing. The UI is completly independent of the profiler. It can be used without it. You will have access to all allocations and to some basic statistics.

## How to profile your specific type of object

You need to create a sublclass of `MpObjectAllocationProfilerHandler` and define the instance side method `classesToRegister` with the class.es that you want to capture. This method should return an array. And you also need to define the class side method `prettyName` with a name of your preference. Then the tool will automatically add it.
