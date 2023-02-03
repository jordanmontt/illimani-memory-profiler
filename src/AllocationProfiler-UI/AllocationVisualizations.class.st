"
I am a class that builds the canvas of the different visualizations.
"
Class {
	#name : #AllocationVisualizations,
	#superclass : #Object,
	#instVars : [
		'statsModel',
		'numberOfTopClasses',
		'numberOfTopMethods'
	],
	#category : #'AllocationProfiler-UI'
}

{ #category : #'chart construction' }
AllocationVisualizations >> addLabelsX: xText y: yText forChart: chart [

	(chart xlabel: xText) shape
		color: Color black.
		"fontFamily: 'Impact'."
	(chart ylabel: yText) shape
		color: Color black.
]

{ #category : #visualizations }
AllocationVisualizations >> allocatedObjectsPerSecondLineChartCanvas [

	| chart linePlot |
	linePlot := self createLinePlotForAllocations: statsModel allocations.
	chart := RSChart new.
	chart add: linePlot.
	self tuneChartForLinePlot: chart.
	chart build.
	^ chart canvas
]

{ #category : #visualizations }
AllocationVisualizations >> allocatedObjectsPerSecondPerClassLineChartCanvas [

	| chart linePlot topClassesByNumberOfAllocations legend |
	topClassesByNumberOfAllocations := statsModel groupedAndSortedNAllocatingClasses: numberOfTopClasses.
	chart := RSChart new.
	legend := RSLegend new.
	legend container: chart canvas.
	topClassesByNumberOfAllocations do: [ :aPair |
		linePlot := self createLinePlotForAllocations: aPair value.
		chart add: linePlot.
		legend text: aPair key name withBoxColor: linePlot computeColor ].

	self tuneChartForLinePlot: chart.
	self tuneLegend: legend.
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

{ #category : #visualizations }
AllocationVisualizations >> heatmapAllocatorAllocatedCanvas [

	^ HeatmapAllocatorAllocatedPresenter new
		data: (statsModel topAllocatorsWithAllOfTheirAllocations: numberOfTopClasses);
		build;
		canvas
]

{ #category : #initialization }
AllocationVisualizations >> initialize [

	super initialize.
	numberOfTopClasses := 10.
	numberOfTopMethods := 10
]

{ #category : #accessing }
AllocationVisualizations >> statsModel: aModel [

	statsModel := aModel
]

{ #category : #visualizations }
AllocationVisualizations >> topClassesThatAllocateObjectsBarChartCanvas [

	| chart allocatedObjects |
	allocatedObjects := (statsModel topNAllocationsByClasses: numberOfTopClasses) reversed.

	chart := self createBarChartForAllocations: allocatedObjects.
	self addLabelsX: 'Allocated Objects' y: 'Classes' forChart: chart.
	chart build.
	^ chart canvas
]

{ #category : #visualizations }
AllocationVisualizations >> topMethodsThatAllocateObjectsBarChartCanvas [

	| chart allocatedObjects |
	allocatedObjects := (statsModel topNAllocationsByMethods: numberOfTopMethods) reversed.

	chart := self createBarChartForAllocations: allocatedObjects.
	self addLabelsX: 'Allocated Objects' y: 'Methods' forChart: chart.
	chart build.
	^ chart canvas
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
	chart add: RSVerticalTick new.
	self addLabelsX: 'Seconds' y: 'Allocated Objects' forChart: chart
]

{ #category : #'chart construction' }
AllocationVisualizations >> tuneLegend: legend [

	legend location
		middle;
		right.
	legend legendDo: [ :l | 
		l
			borderColor: 'black';
			scaleBy: 0.5;
			padding: 10 ]
]
