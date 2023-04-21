Class {
	#name : #IllimaniDistributionForFinalization,
	#superclass : #Object,
	#instVars : [
		'data'
	],
	#category : #'IllimaniAllocationProfiler-UI-Roassal'
}

{ #category : #'as yet unclassified' }
IllimaniDistributionForFinalization >> data: someData [

	data := someData
]

{ #category : #'as yet unclassified' }
IllimaniDistributionForFinalization >> palu1 [

	| canvas plot onlyFinalizedObjects groupedData |
	onlyFinalizedObjects := data select: [ :e | e finalizationTimestamp isNotNil ].
	"Grouped data by seconds"
	groupedData := (onlyFinalizedObjects groupedBy: [ :e | e lifetimeAsDuration seconds ]) associations.
	"groupedData := (onlyFinalizedObjects groupedBy: [ :e | e lifetimeAsDuration asMilliSeconds / 100 ]) associations."

	canvas := RSChart new.
	plot := RSScatterPlot new x: (groupedData collect: #key)
		        y: (groupedData collect: [ :e | e value size ]).

	canvas addPlot: plot.

	canvas xlabel: 'X Axis'.
	canvas ylabel: 'Y Axis'.

	canvas addDecoration: (RSHorizontalTick new
			 numberOfTicks: 10;
			 yourself).
	canvas addDecoration: (RSVerticalTick new
			 numberOfTicks: 10;
			 labelConversion: [ :e | e asInteger printString ];
			 yourself).
	canvas addDecoration: RSXMarkerDecoration new average.

	canvas yLog.

	^ canvas
]

{ #category : #'as yet unclassified' }
IllimaniDistributionForFinalization >> palu2 [

	| c p |
	"data := OrderedCollection new.
self associationsDo: [ :e | ((e key < 51)) ifTrue: [ data add: e]]."
	c := RSChart new.
	p := RSScatterPlot new x: (data collect: #key)
		     y: (data collect: [ :e | e value sum: #totalSizeInBytes ]).

	c addPlot: p.

	c xlabel: 'X Axis'.
	c ylabel: 'Y Axis'.

	c addDecoration: (RSHorizontalTick new
			 numberOfTicks: 10;
			 yourself).
	c addDecoration: (RSVerticalTick new
			 numberOfTicks: 10;
			 yourself).
	c addDecoration: RSYMarkerDecoration new average.
	c addDecoration: RSXMarkerDecoration new average.
	c addDecoration: (RSVerticalTick new
			 numberOfTicks: 10;
			 labelConversion: [ :e | e asInteger printString ];
			 yourself).

	c yLog.

	^ c
]

{ #category : #'as yet unclassified' }
IllimaniDistributionForFinalization >> palu3 [

	| canvas plot onlyFinalizedObjects groupedData |

	onlyFinalizedObjects := data select: [ :e | e finalizationTimestamp isNotNil ].
	"Grouped data by seconds"
	groupedData := (onlyFinalizedObjects groupedBy: [ :e | e lifetimeAsDuration asMilliSeconds / 10 ]) associations.
	groupedData := (groupedData sorted: [ :a :b | a key < b key ]) collect: [ :e | e key asFloat -> e value ].

	canvas := RSChart new.
	plot := RSAreaPlot new
		x: (groupedData collect: [ :e | e key ])
		y1: (groupedData collect: [ :e | e value size ])
		y2: 0.

	canvas addPlot: plot.

	canvas xlabel: 'X Axis'.
	canvas ylabel: 'Y Axis'.

	canvas addDecoration: (RSHorizontalTick new
			 numberOfTicks: 10;
			 yourself).
	canvas addDecoration: (RSVerticalTick new
			 numberOfTicks: 10;
			 labelConversion: [ :e | e asInteger printString ];
			 yourself).
	canvas addDecoration: RSXMarkerDecoration new average.

	canvas yLog.

	^ canvas
]

{ #category : #'as yet unclassified' }
IllimaniDistributionForFinalization >> palu4 [

	| canvas plot onlyFinalizedObjects groupedData x y line90 |
	canvas := RSChart new.
	onlyFinalizedObjects := data select: [ :e | e finalizationTimestamp isNotNil ].
	"Grouped data by seconds"
	groupedData := (onlyFinalizedObjects groupedBy: [ :e | e lifetimeAsDuration asDeciSeconds ceiling ]) associations.
	
	groupedData := groupedData sorted: [ :a :b | a key < b key ].
	x := 0 to: groupedData last key asInteger. "#(0 1 2 3 ...)"
	groupedData := Dictionary newFrom: groupedData.
	y := x collect: [ :index | groupedData at: index
		ifPresent: [ :collection | collection size ]
		ifAbsent: [ 0 ] ].
	plot := RSLinePlot new
		x: x
		y: y.

	canvas addPlot: plot.

	canvas addDecoration: (RSHorizontalTick new
			 numberOfTicks: 10;
			 yourself).
	canvas addDecoration: (RSVerticalTick new
			 numberOfTicks: 10;
			 labelConversion: [ :e | e asInteger printString ];
			 yourself).
	canvas addDecoration: (line90 := RSXMarkerDecoration new
		value: [ 100 ]).
		

	canvas yLog.
	
	canvas xlabel: 'Lifetime'.
	canvas ylabel: 'Number of objects'.
	canvas title: 'Palu4'.

	canvas build.
	
	line90 lines do: [ :line | | label |
		label := RSLabel new
			text: '90%';
			fontSize: 10;
			color: Color black;
			yourself.
		RSLocation new
			above;
			move: label on: line.
		canvas canvas add: label.
		 ].
	^ canvas canvas.
]
