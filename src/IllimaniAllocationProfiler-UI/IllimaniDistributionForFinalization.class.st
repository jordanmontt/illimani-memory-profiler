Class {
	#name : #IllimaniDistributionForFinalization,
	#superclass : #Object,
	#instVars : [
		'data',
		'groupedData',
		'timeMeasurement',
		'groupingBlock',
		'x',
		'y',
		'yTransformingBlock'
	],
	#category : #'IllimaniAllocationProfiler-UI-Roassal'
}

{ #category : #api }
IllimaniDistributionForFinalization >> applyGroupData [

	| onlyFinalizedObjects dictionary |
	
	onlyFinalizedObjects := data select: [ :e | e finalizationTimestamp isNotNil ].

	groupedData := (onlyFinalizedObjects groupedBy: [ :collection |
		                groupingBlock value: collection ]) associations.
	groupedData sort: [ :a :b | a key < b key ].

	x := 0 to: groupedData last key asInteger.
	dictionary := Dictionary newFrom: groupedData.
	y := x collect: [ :index |
		     dictionary at: index
			     ifPresent: [ :collection | yTransformingBlock value: collection ]
			     ifAbsent: [ 0 ] ]
]

{ #category : #api }
IllimaniDistributionForFinalization >> data: someData [

	data := someData
]

{ #category : #initialization }
IllimaniDistributionForFinalization >> groupingBlock: aBlock [

	groupingBlock := aBlock
]

{ #category : #initialization }
IllimaniDistributionForFinalization >> initialize [

	super initialize.
	groupingBlock := [ :allocationModel |
		allocationModel lifetimeAsDuration asDeciSeconds ceiling ].
	"yTransformingBlock := [ :collection | collection size ]."
	yTransformingBlock := [ :collection | collection sum: #totalSizeInBytes ].
	self timeMeasurement: 'deci seconds'
]

{ #category : #'old - visualizations' }
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

{ #category : #'old - visualizations' }
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

{ #category : #'old - visualizations' }
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

{ #category : #api }
IllimaniDistributionForFinalization >> palu4 [

	| chart plot marker90Percent marker10Percent markerColor |
	chart := RSChart new.

	plot := RSLinePlot new
		        color: Color black;
		        x: x y: y.

	chart addPlot: plot.

	chart addDecoration: (RSHorizontalTick new
			 numberOfTicks: 10;
			 labelConversion: [ :e | e asInteger printString ];
			 yourself).
	chart addDecoration: (RSVerticalTick new
			 numberOfTicks: 10;
			 labelConversion: [ :e | e asInteger humanReadableByteSizeString ];
			 yourself).
	markerColor := Color fromHexString: '922724'.
	chart addDecoration: (marker90Percent := RSXMarkerDecoration new
			                    sumUpTo: 0.9;
			                    color: markerColor;
			                    yourself).
	chart addDecoration: (marker10Percent := RSXMarkerDecoration new
			                    sumUpTo: 0.1;
			                    color: markerColor;
			                    yourself).

	chart yLog.

	chart xlabel: 'Lifetime in ' , timeMeasurement.
	chart ylabel: 'Memory'.
	chart title: 'Palu4'.

	chart build.

	marker90Percent lines do: [ :line |
		| label |
		label := RSLabel new
			         text: '90%';
			         color: markerColor;
			         fontSize: 6;
			         yourself.
		RSLocation new
			above;
			move: label on: line.
		chart canvas add: label ].

	marker10Percent lines do: [ :line |
		| label |
		label := RSLabel new
			         text: '10%';
			         color: markerColor;
			         fontSize: 6;
			         yourself.
		RSLocation new
			above;
			move: label on: line.
		chart canvas add: label ].
	^ chart canvas
]

{ #category : #api }
IllimaniDistributionForFinalization >> timeMeasurement: aString [
	"The string needs to be in lowercase"

	timeMeasurement := aString
]

{ #category : #initialization }
IllimaniDistributionForFinalization >> yTransformingBlock: aBlock [

	yTransformingBlock := aBlock
]
