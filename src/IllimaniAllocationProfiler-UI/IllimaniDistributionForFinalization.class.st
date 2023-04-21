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
