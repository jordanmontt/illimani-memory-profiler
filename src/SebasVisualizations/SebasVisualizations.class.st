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

{ #category : #visualization }
SebasVisualizations >> lineChart [
	<script: 'self new allocations: (Smalltalk at: #allocations); lineChart'>
	| chart times values line |
	chart := RSChart new.
	times := allocations collect: [:each | 
		each timestamp asNanoSeconds - 
		allocations first timestamp asNanoSeconds ].
	values := 1 to: times size.
	line := RSLinePlot new x: times y: values.
	chart add: line.
	chart add: (RSVerticalTick new).
	chart add: (RSHorizontalTick new
		labelConversion: [ :number | 
			(number / (10 raisedTo: 9)) asFloat.
			]
		).
	(chart xlabel: 'Seconds') shape
		color: Color black;
		fontFamily: 'Impact'.
	(chart ylabel: 'Number of instances created') shape
		color: Color black;
		fontFamily: 'Impact'.
	chart open.
]

{ #category : #visualization }
SebasVisualizations >> lineChartByClasses [
	<script: 'self new allocations: (Smalltalk at: #allocations); lineChartByClasses'>
	| chart groups times values plot subAllocation sortedKeys lb |
	chart := RSChart new.
	groups := allocations groupedBy: [ :holder | holder context methodClass ].
	sortedKeys := groups keys sorted: [ :key1 :key2 | (groups at: key1) size > (groups at: key2) size ].
	lb := RSLegend new.
	lb container: chart canvas.
	(sortedKeys first: 3) do: [ :class |
		subAllocation := groups at: class.
		times := subAllocation collect: [:each | 
			each timestamp asNanoSeconds - 
			allocations first timestamp asNanoSeconds ].
		values := 1 to: times size.
		
		plot := RSLinePlot new x: times y: values.
		chart add: plot.
		lb text: class name withBoxColor: plot computeColor.
	].
	chart add: (RSVerticalTick new).
	chart add: (RSHorizontalTick new
		labelConversion: [ :number | 
			(number / (10 raisedTo: 9)) asFloat.
			]
		).
	(chart xlabel: 'Seconds') shape
		color: Color black;
		fontFamily: 'Impact'.
	(chart ylabel: 'Number of instances created') shape
		color: Color black;
		fontFamily: 'Impact'.
	lb location middle; right.
	lb legendDo: [ :l |
		l 
			borderColor: 'black';
			scaleBy: 0.5;
			padding: 10. ].
	chart build.
	lb build.
	chart canvas open.
]
