"
I am a class that builds the canvas of the different visualizations.
"
Class {
	#name : #IllimaniRoassalChartBuilder,
	#superclass : #Object,
	#instVars : [
		'topCalculationsNumber',
		'model'
	],
	#category : #'AllocationProfiler-UI-Roassal'
}

{ #category : #'instance creation' }
IllimaniRoassalChartBuilder class >> on: aModel [

	^ self new
		  model: aModel;
		  yourself
]

{ #category : #'chart construction' }
IllimaniRoassalChartBuilder >> addLabelsX: xText y: yText forChart: chart [

	(chart xlabel: xText) shape color: Color black.
	(chart ylabel: yText) shape color: Color black
]

{ #category : #'chart construction' }
IllimaniRoassalChartBuilder >> addTicksToLabel: chart [

	chart add: (RSHorizontalTick new
		"Divide by 10^9 because the time is in nanoseconds"
		labelConversion: [ :number | (number / (10 raisedTo: 9)) asFloat ];
		yourself).
	chart add: RSVerticalTick new
]

{ #category : #'api - line chart' }
IllimaniRoassalChartBuilder >> allocatedObjectsPerSecondLineChartCanvas [

	| chart linePlot |
	linePlot := self createLinePlotForAllocations: model objectAllocations.
	chart := RSChart new.
	chart add: linePlot.
	self addTicksToLabel: chart.
	self addLabelsX: 'Seconds' y: 'Total Allocated Objects' forChart: chart.
	chart build.
	^ chart canvas
]

{ #category : #'api - line chart' }
IllimaniRoassalChartBuilder >> allocatedObjectsPerSecondPerClassLineChartCanvas [

	| chart linePlot legend |
	chart := RSChart new.
	legend := RSLegend new
		container: chart canvas;
		yourself.
	(model stats topNAllocationsByClass: topCalculationsNumber) do: [ :anAllocationNode |
		linePlot := self createLinePlotForAllocations: anAllocationNode sortedGroupedAllocations.
		chart add: linePlot.
		legend text: anAllocationNode allocator asString withBoxColor: linePlot computeColor ].

	self addTicksToLabel: chart.
	self addLabelsX: 'Seconds' y: 'Allocators' forChart: chart.

	legend location
		middle;
		right.
	legend legendDo: [ :l |
		l
			borderColor: 'black';
			scaleBy: 0.5;
			padding: 10 ].

	chart build.
	legend build.
	^ chart canvas
]

{ #category : #'api - line chart' }
IllimaniRoassalChartBuilder >> allocatedObjectsPerSecondPerMethodLineChartCanvas [

	| chart linePlot legend |
	chart := RSChart new.
	legend := RSLegend new
		container: chart canvas;
		yourself.
	(model stats topNAllocationsByMethod: topCalculationsNumber) do: [ :anAllocationNode |
		linePlot := self createLinePlotForAllocations: anAllocationNode sortedGroupedAllocations.
		chart add: linePlot.
		legend text: anAllocationNode allocator asString withBoxColor: linePlot computeColor ].

	self addTicksToLabel: chart.
	self addLabelsX: 'Seconds' y: 'Allocators' forChart: chart.

	legend location
		middle;
		right.
	legend legendDo: [ :l |
		l
			borderColor: 'black';
			scaleBy: 0.5;
			padding: 10 ].

	chart build.
	legend build.
	^ chart canvas
]

{ #category : #'chart construction' }
IllimaniRoassalChartBuilder >> createBarChartForAllocations: allocatedObjects [

	| chart barPlot indices |
	chart := RSChart new.
	indices := 1 to: allocatedObjects size.
	barPlot := RSHorizontalBarPlot new x: (allocatedObjects collect: #totalAllocations) y: indices.
	chart addPlot: barPlot.
	self tuneBarChart: chart forNames: (allocatedObjects collect: #allocator).
	^ chart
]

{ #category : #'chart construction' }
IllimaniRoassalChartBuilder >> createLinePlotForAllocations: someAllocations [

	| times linePlot indices sortedByTime |
	sortedByTime := someAllocations sorted: [ :a :b | a timestamp < b timestamp ].

	"Roassal does not accepts Duration"
	times := sortedByTime collect: [ :each | each timestamp asNanoSeconds ].
	"To start in 0"
	times := times collect: [ :e | e - sortedByTime first timestamp asNanoSeconds ].

	indices := 1 to: times size.
	linePlot := RSLinePlot new x: times y: indices.
	^ linePlot
]

{ #category : #'api - heatmap' }
IllimaniRoassalChartBuilder >> heatmapAllocatorAllocatedCanvas [

	^ HeatmapAllocatorAllocated new
		data: (model stats topNAllocationsByClass: topCalculationsNumber);
		build;
		canvas
]

{ #category : #'api - heatmap' }
IllimaniRoassalChartBuilder >> heatmapAllocatorAllocatedCanvasByClass [

	^ HeatmapAllocatorAllocated new
		data: (model stats topNAllocationsByClass: topCalculationsNumber);
		build;
		canvas
]

{ #category : #'api - heatmap' }
IllimaniRoassalChartBuilder >> heatmapAllocatorAllocatedCanvasByMethod [

	^ HeatmapAllocatorAllocated new
		data: (model stats topNAllocationsByMethod: topCalculationsNumber);
		build;
		canvas
]

{ #category : #accessing }
IllimaniRoassalChartBuilder >> model: aModel [

	model := aModel
]

{ #category : #'api - bar chart' }
IllimaniRoassalChartBuilder >> topAllocatorClassesBarChartCanvas [

	| chart allocatedObjects |
	allocatedObjects := model stats topNAllocationsByClass: topCalculationsNumber.

	chart := self createBarChartForAllocations: allocatedObjects.
	self addLabelsX: 'Allocated Objects' y: 'Allocator Classes' forChart: chart.
	chart build.
	^ chart canvas
]

{ #category : #'api - bar chart' }
IllimaniRoassalChartBuilder >> topAllocatorMethodsBarChartCanvas [

	| chart allocatedObjects |
	allocatedObjects := model stats topNAllocationsByMethod: topCalculationsNumber.

	chart := self createBarChartForAllocations: allocatedObjects.
	self addLabelsX: 'Allocated Objects' y: 'Allocator Methods' forChart: chart.
	chart build.
	^ chart canvas
]

{ #category : #accessing }
IllimaniRoassalChartBuilder >> topCalculationsNumber: aNumber [

	topCalculationsNumber := aNumber
]

{ #category : #'chart construction' }
IllimaniRoassalChartBuilder >> tuneBarChart: chart forNames: allocatedObjectNames [

	chart add: (RSHorizontalTick new
			 useNiceLabel;
			 yourself).
	chart addDecoration: (RSVerticalTick new
			 fromNames: allocatedObjectNames;
			 yourself).

	chart padding: 5
]
