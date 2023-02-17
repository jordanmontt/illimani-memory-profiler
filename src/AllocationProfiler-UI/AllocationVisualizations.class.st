"
I am a class that builds the canvas of the different visualizations.
"
Class {
	#name : #AllocationVisualizations,
	#superclass : #Object,
	#instVars : [
		'topCalculationsNumber',
		'model'
	],
	#category : #'AllocationProfiler-UI-Visualizations'
}

{ #category : #'instance creation' }
AllocationVisualizations class >> on: aModel [

	^ self new
		  model: aModel;
		  yourself
]

{ #category : #'chart construction' }
AllocationVisualizations >> addLabelsX: xText y: yText forChart: chart [

	(chart xlabel: xText) shape
		color: Color black.
		"fontFamily: 'Impact'."
	(chart ylabel: yText) shape
		color: Color black.
]

{ #category : #'api - visualizations' }
AllocationVisualizations >> allocatedObjectsPerSecondLineChartCanvas [

	| chart linePlot |
	linePlot := self createLinePlotForAllocations: model objectAllocations.
	chart := RSChart new.
	chart add: linePlot.
	self tuneChartForLinePlot: chart.
	self addLabelsX: 'Seconds' y: 'Total Allocated Objects' forChart: chart.
	chart build.
	^ chart canvas
]

{ #category : #'api - visualizations' }
AllocationVisualizations >> allocatedObjectsPerSecondPerClassLineChartCanvas [

	| chart linePlot topClassesByNumberOfAllocations legend |
	topClassesByNumberOfAllocations := model stats topGroupedAndSortedAllocatingClasses: topCalculationsNumber.
	chart := RSChart new.
	legend := RSLegend new.
	legend container: chart canvas.
	topClassesByNumberOfAllocations do: [ :aPair |
		linePlot := self createLinePlotForAllocations: aPair value.
		chart add: linePlot.
		legend text: aPair key name withBoxColor: linePlot computeColor ].

	self tuneChartForLinePlot: chart.
	self addLabelsX: 'Seconds' y: 'Allocator Classes' forChart: chart.

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
AllocationVisualizations >> createBarChartForAllocations: allocatedObjects [

	| chart barPlot indices |
	chart := RSChart new.
	indices := 1 to: allocatedObjects size.
	barPlot := RSHorizontalBarPlot new x: (allocatedObjects collect: #value) y: indices.
	chart addPlot: barPlot.
	self tuneBarChart: chart forNames: (allocatedObjects collect: #key).
	^ chart
]

{ #category : #'chart construction' }
AllocationVisualizations >> createLinePlotForAllocations: someAllocations [

	| times linePlot indices |
	"The times are in nano seconds"
	times := someAllocations collect: [ :each | each timestamp asNanoSeconds ].
	"To start in 0"
	times := times - someAllocations first timestamp asNanoSeconds.
	indices := 1 to: times size.

	linePlot := RSLinePlot new x: times y: indices.
	^ linePlot
]

{ #category : #'api - visualizations' }
AllocationVisualizations >> heatmapAllocatorAllocatedCanvas [

	^ HeatmapAllocatorAllocated new
		data: (model stats topAllocatorsWithAllOfTheirAllocations: topCalculationsNumber);
		build;
		canvas
]

{ #category : #accessing }
AllocationVisualizations >> model: aModel [

	model := aModel
]

{ #category : #'api - visualizations' }
AllocationVisualizations >> topAllocatorClassesBarChartCanvas [

	| chart allocatedObjects |
	allocatedObjects := (model stats topNAllocationsByClasses: topCalculationsNumber) reversed.

	chart := self createBarChartForAllocations: allocatedObjects.
	self addLabelsX: 'Allocated Objects' y: 'Allocator Classes' forChart: chart.
	chart build.
	^ chart canvas
]

{ #category : #'api - visualizations' }
AllocationVisualizations >> topAllocatorMethodsBarChartCanvas [

	| chart allocatedObjects |
	allocatedObjects := (model stats topNAllocationsByMethods: topCalculationsNumber) reversed.

	chart := self createBarChartForAllocations: allocatedObjects.
	self addLabelsX: 'Allocated Objects' y: 'Allocator Methods' forChart: chart.
	chart build.
	^ chart canvas
]

{ #category : #accessing }
AllocationVisualizations >> topCalculationsNumber: aNumber [

	topCalculationsNumber := aNumber
]

{ #category : #'chart construction' }
AllocationVisualizations >> tuneBarChart: chart forNames: allocatedObjectNames [

	chart add:( RSHorizontalTick new
		useNiceLabel;
		yourself).
	chart addDecoration: (RSVerticalTick new
		fromNames: allocatedObjectNames;
		yourself).
		
	chart padding: 5
]

{ #category : #'chart construction' }
AllocationVisualizations >> tuneChartForLinePlot: chart [

	chart add: (RSHorizontalTick new
		"Divide by 10^9 because the time is in nanoseconds"
		labelConversion: [ :number | (number / (10 raisedTo: 9)) asFloat ];
		yourself).
	chart add: RSVerticalTick new
]
