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
	#category : #'IllimaniAllocationProfiler-UI-Roassal'
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

	chart
		add: RSHorizontalTick new;
		add: (RSVerticalTick new
			labelConversion: [ :value | value asInteger asStringWithCommas ];
			yourself)
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

	^ self constructPerSecondLineChart:
		  (model stats topNAllocationsByClass: topCalculationsNumber)
]

{ #category : #'api - line chart' }
IllimaniRoassalChartBuilder >> allocatedObjectsPerSecondPerMethodLineChartCanvas [

	^ self constructPerSecondLineChart:
		  (model stats topNAllocationsByMethod: topCalculationsNumber)
]

{ #category : #'chart construction' }
IllimaniRoassalChartBuilder >> constructPerSecondLineChart: aCollection [

	| chart linePlot legend |
	chart := RSChart new.
	legend := RSLegend new
		container: chart canvas;
		yourself.
	aCollection do: [ :anAllocationNode |
		linePlot := self createLinePlotForAllocations: anAllocationNode sortedGroupedAllocations.
		chart add: linePlot.
		legend text: anAllocationNode allocator asString withBoxColor: linePlot computeColor ].

	self addTicksToLabel: chart.
	self addLabelsX: 'Seconds' y: 'Allocations' forChart: chart.

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
IllimaniRoassalChartBuilder >> createLinePlotForAllocations: someAllocations [

	| times linePlot indices sortedByTime |
	sortedByTime := someAllocations sorted: [ :a :b | a initializationTimestamp < b initializationTimestamp ].

	"Roassal does not accepts Duration"
	times := sortedByTime collect: [ :each | each timestampAsSeconds ].
	"To start in 0"
	times := times collect: [ :e | (e - sortedByTime first timestampAsSeconds) asFloat ].

	indices := 1 to: times size.
	linePlot := RSLinePlot new x: times y: indices.
	^ linePlot
]

{ #category : #'api - heatmap' }
IllimaniRoassalChartBuilder >> heatmapAllocatorAllocatedCanvasByClass [

	^ IllimaniHeatmapRoassalBuilder new
		data: (model stats topNAllocationsByClass: topCalculationsNumber);
		build;
		canvas
]

{ #category : #'api - heatmap' }
IllimaniRoassalChartBuilder >> heatmapAllocatorAllocatedCanvasByMethod [

	^ IllimaniHeatmapRoassalBuilder new
		data: (model stats topNAllocationsByMethod: topCalculationsNumber);
		build;
		canvas
]

{ #category : #accessing }
IllimaniRoassalChartBuilder >> model: aModel [

	model := aModel
]

{ #category : #accessing }
IllimaniRoassalChartBuilder >> topCalculationsNumber: aNumber [

	topCalculationsNumber := aNumber
]
