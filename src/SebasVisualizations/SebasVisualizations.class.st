"
Soy una clase cool que muestra visualizaciones
"
Class {
	#name : #SebasVisualizations,
	#superclass : #Object,
	#instVars : [
		'allocations'
	],
	#category : #SebasVisualizations
}

{ #category : #accessing }
SebasVisualizations >> allocations: aCollection [

	allocations := aCollection
]

{ #category : #visualization }
SebasVisualizations >> barChart [

	| chart barPlot ocurrences names y x |
	names := OrderedCollection new.
	y := OrderedCollection new.
	ocurrences := Bag newFrom: (allocations collect: [:e | e context methodClass]).
	ocurrences doWithOccurrences: [ :key : value |
		y add: value.
		names add: key name ].
	x := 1 to: names size.

	chart := RSChart new.
	barPlot := RSBarPlot new x: x y: y.

	chart addPlot: barPlot.
	chart add: RSVerticalTick new.
	chart addDecoration: (RSHorizontalTick new
		useVerticalLabel;
		fromNames: names;
		yourself).

	chart build.
	barPlot bars @ RSPopup.
	^ chart canvas
]

{ #category : #defaults }
SebasVisualizations >> createLinePlotForAllocations: someAllocations [

	| times linePlot values |
	"The times are in nano seconds"
	times := someAllocations collect: [ :each | each timestamp asNanoSeconds ].
	"To start in 0"
	times := times - allocations first timestamp asNanoSeconds.
	values := 1 to: times size.

	linePlot := RSLinePlot new x: times y: values.
	^ linePlot
]

{ #category : #visualization }
SebasVisualizations >> lineChart [

	| chart linePlot |
	linePlot := self createLinePlotForAllocations: allocations.
	chart := RSChart new.
	chart add: linePlot.
	self tuneChartForLinePlot: chart.
	chart build.
	^ chart canvas
]

{ #category : #visualization }
SebasVisualizations >> lineChartTopClasses [

	| chart classGroups linePlot sortedGroupKeys legend |
	classGroups := allocations groupedBy: [ :holder | holder context methodClass ].
	sortedGroupKeys := classGroups keys sorted: [ :key1 :key2 | 
		(classGroups at: key1) size > (classGroups at: key2) size ].
	sortedGroupKeys := sortedGroupKeys first: 3.
	
	chart := RSChart new.
	legend := RSLegend new.
	legend container: chart canvas.
	sortedGroupKeys do: [ :class | 
		| subAllocations  |
		subAllocations := classGroups at: class.
		linePlot := self createLinePlotForAllocations: subAllocations.
		chart add: linePlot.
		legend text: class name withBoxColor: linePlot computeColor ].
	
	self tuneChartForLinePlot: chart.
	legend location
		middle;
		right.
	legend legendDo: [ :l | l
		borderColor: 'black';
		scaleBy: 0.5;
		padding: 10 ].
	chart build.
	legend build.
	^ chart canvas
]

{ #category : #defaults }
SebasVisualizations >> tuneChartForLinePlot: chart [

	chart add: (RSHorizontalTick new
		labelConversion: [ :number | (number / (10 raisedTo: 9)) asFloat ];
		yourself).
	chart add: RSVerticalTick new.
	(chart xlabel: 'Seconds') shape
		color: Color black;
		fontFamily: 'Impact'.
	(chart ylabel: 'Number of instances created') shape
		color: Color black;
		fontFamily: 'Impact'
]
