"
I am a class that builds the canvas of the different visualizations.
"
Class {
	#name : 'IllRoassalChartBuilder',
	#superclass : 'Object',
	#instVars : [
		'topCalculationsNumber',
		'model'
	],
	#category : 'IllimaniUI-Roassal',
	#package : 'IllimaniUI',
	#tag : 'Roassal'
}

{ #category : 'instance creation' }
IllRoassalChartBuilder class >> on: aModel [

	^ self new
		  model: aModel;
		  yourself
]

{ #category : 'chart construction' }
IllRoassalChartBuilder >> addLabelsX: xText y: yText forChart: chart [

	(chart xlabel: xText) shape color: Color black.
	(chart ylabel: yText) shape color: Color black
]

{ #category : 'chart construction' }
IllRoassalChartBuilder >> addTicksToLabel: chart [

	chart verticalTick labelConversion: [ :value | value asInteger asStringWithCommas ]
]

{ #category : 'api - line chart' }
IllRoassalChartBuilder >> allocatedObjectsPerSecondLineChartCanvas [

	| chart linePlot |
	linePlot := self createLinePlotForAllocations: model objectAllocations.
	
	chart := self initializeChart.
	
	chart add: linePlot.
	self addTicksToLabel: chart.
	self addLabelsX: 'Seconds' y: 'Total Allocated Objects' forChart: chart.
	chart build.
	^ chart canvas
]

{ #category : 'api - line chart' }
IllRoassalChartBuilder >> allocatedObjectsPerSecondPerClassLineChartCanvas [

	^ self constructPerSecondLineChart:
		  (model stats topNAllocationsByClass: topCalculationsNumber)
]

{ #category : 'api - line chart' }
IllRoassalChartBuilder >> allocatedObjectsPerSecondPerMethodLineChartCanvas [

	^ self constructPerSecondLineChart:
		  (model stats topNAllocationsByMethod: topCalculationsNumber)
]

{ #category : 'chart construction' }
IllRoassalChartBuilder >> constructPerSecondLineChart: aCollection [

	| chart linePlot legend |

	chart := self initializeChart.

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

{ #category : 'chart construction' }
IllRoassalChartBuilder >> createLinePlotForAllocations: someAllocations [

	| times linePlot indices sortedByTime |
	sortedByTime := someAllocations sorted: [ :a :b | a initializationTime < b initializationTime ].

	"Roassal does not accepts Duration"
	times := sortedByTime collect: [ :each | each timeAsSeconds ].
	"To start in 0"
	times := times collect: [ :e | (e - sortedByTime first timeAsSeconds) asFloat ].

	indices := 1 to: times size.
	linePlot := RSLinePlot new x: times y: indices.
	^ linePlot
]

{ #category : 'api - heatmap' }
IllRoassalChartBuilder >> heatmapAllocatorAllocatedCanvasByClass [

	^ IllHeatmapRoassalBuilder new
		data: (model stats topNAllocationsByClass: topCalculationsNumber);
		build;
		canvas
]

{ #category : 'api - heatmap' }
IllRoassalChartBuilder >> heatmapAllocatorAllocatedCanvasByMethod [

	^ IllHeatmapRoassalBuilder new
		data: (model stats topNAllocationsByMethod: topCalculationsNumber);
		build;
		canvas
]

{ #category : 'api - line chart' }
IllRoassalChartBuilder >> initializeChart [

	^ RSCompositeChart new
		  colors: NSScale google20;
		  yourself
]

{ #category : 'accessing' }
IllRoassalChartBuilder >> model: aModel [

	model := aModel
]

{ #category : 'accessing' }
IllRoassalChartBuilder >> topCalculationsNumber: aNumber [

	topCalculationsNumber := aNumber
]