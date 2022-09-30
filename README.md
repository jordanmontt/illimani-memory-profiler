# object-creation-pharo-experiment

```st
h := MpColorAllocationProfilerHandler new.
p1 := MpMethodProxy 
	onMethod: Behavior >> #basicNew 
	handler: h.
p1 install.
p2 := MpMethodProxy 
	onMethod: Behavior >> #basicNew: 
	handler: h.
p2 install.
h.

p1 uninstall.
p2 uninstall.


sebasVisualizations := SebasVisualizations new
	allocations: h allocations.
barChart :=	sebasVisualizations barChart.
lineChart :=	sebasVisualizations lineChart.
lineChartTopClasses :=	sebasVisualizations lineChartTopClasses.
```
