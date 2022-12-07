# object-creation-pharo-experiment

## How to install it

```st
Metacello new
  baseline: 'AllocationProfiler';
  repository: 'github://jordanmontt/object-creation-pharo-experiment:main';
  load.
```

## How to use it

You need to instantiate an `ObjectInstantiationWatcher`. You can watch either the colors or the points allocations.

```st
objectAllocationProfiler := ObjectAllocationProfiler new.

objectAllocationProfiler startProfiling.
objectAllocationProfiler stopProfiling.

objectAllocationProfiler proxyHandler inspect
```

In the inspector you will able to see all the that are presented here visualizations and also a presenter with the stats.

For watching points:

```st
objectAllocationProfiler proxyHandler: MpPointAllocationProfilerHandler new
```

## Results

All this (mini) experiments were rur for 60 approximatively seconds and in a Pharo 11 image.

### 1. Watching a brand new image and using it normally

I downloaded a Pharo 11 image. Opened `iceberg`. Installed this repository. Opened a Playground.

Then I run the code in the how to use it section and the method proxies watched the allocations for 60 seconds.

Then, I use the image like a normally do: I opened the system browser. Write code. Save a method. Commit to `iceberg`. I also opened the remote part on `iceberg` which contains a Form. Maybe that is why we have ~4000 different colors created (?)

|     |     |
| --- | --- |
| Classes that allocate a Color object | 46 |
| Methods that allocate a Color object | 90  |
| Total allocated colors | 26932 |
| Total allocated unique colors | 4323  |

![](./img/new%20image%20using%20it%20normally%20opening%20remtotes/line.png)

![](./img/new%20image%20using%20it%20normally%20opening%20remtotes/line-3-classes.png)

Top 10 hot classes that allocates colors objects

![](./img/new%20image%20using%20it%20normally%20opening%20remtotes/bar-classes.png)

Top 10 hot methods that allocates colors objects

![](./img/new%20image%20using%20it%20normally%20opening%20remtotes/bar-methods.png)

### 2. Watching a one week image and using it normally

For this part, I did the same as in the last experiment, except that I used an image that had 1 week old. It was an image that was not that much used. It was only used for 2 hours in total approximately.

|     |     |
| --- | --- |
| Classes that allocate a Color object | 34 |
| Methods that allocate a Color object | 68  |
| Total allocated colors | 22670 |
| Total allocated unique colors | 56 |

![](./img/used%20image%20using%20it%20normally/line.png)

![](./img/used%20image%20using%20it%20normally/line-3-classes.png)

Top 10 hot classes that allocates colors objects

![](./img/used%20image%20using%20it%20normally/classes-bar.png)

Top 10 hot methods that allocates colors objects

![](./img/used%20image%20using%20it%20normally/mathods-bar.png)

_Note: This is only a first approach to investigate why we create so many unnecessary colors in Pharo. More rigorous experiment are required to drop to consistent conclusions_
