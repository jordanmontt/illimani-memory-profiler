"
I am a class that builds the canvas of the different visualizations.
"
Class {
	#name : 'RoassaHelperChartBuilder',
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
RoassaHelperChartBuilder class >> on: aModel [

	^ self new
		  model: aModel;
		  yourself
]

{ #category : 'chart construction' }
RoassaHelperChartBuilder >> addLabelsX: xText y: yText forChart: chart [

	(chart xlabel: xText) shape color: Color black.
	(chart ylabel: yText) shape color: Color black
]

{ #category : 'chart construction' }
RoassaHelperChartBuilder >> addTicksToLabel: chart [

	chart verticalTick labelConversion: [ :value | value asInteger asStringWithCommas ]
]

{ #category : 'api - line chart' }
RoassaHelperChartBuilder >> allocatedObjectsPerSecondLineChartCanvas [

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
RoassaHelperChartBuilder >> allocatedObjectsPerSecondPerMethodLineChartCanvas [

	^ self constructPerSecondLineChart:
		  (model allocationsStats topNAllocationsByMethod: topCalculationsNumber)
]

{ #category : 'chart construction' }
RoassaHelperChartBuilder >> constructPerSecondLineChart: aCollection [

	| chart linePlot legend |

	chart := self initializeChart.

	legend := RSLegend new
		container: chart canvas;
		yourself.
	aCollection do: [ :anAllocationNode |
		linePlot := self createLinePlotForAllocations: anAllocationNode sortedGroupedAllocations.
		chart add: linePlot.
		legend text: anAllocationNode allocator name withBoxColor: linePlot computeColor ].

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
RoassaHelperChartBuilder >> createLinePlotForAllocations: someAllocations [

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
RoassaHelperChartBuilder >> heatmapAllocatorAllocatedCanvasByMethod [

	^ HeatmapRoassalBuilder new
		data: (model allocationsStats topNAllocationsByMethod: topCalculationsNumber);
		build;
		canvas
]

{ #category : 'api - line chart' }
RoassaHelperChartBuilder >> initializeChart [

	^ RSCompositeChart new
		  colors: NSScale google20;
		  yourself
]

{ #category : 'accessing' }
RoassaHelperChartBuilder >> model: aModel [

	model := aModel
]

{ #category : 'accessing' }
RoassaHelperChartBuilder >> topCalculationsNumber: aNumber [

	topCalculationsNumber := aNumber
]
