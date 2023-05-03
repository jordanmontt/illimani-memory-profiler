Class {
	#name : #IllimaniDistributionForFinalization,
	#superclass : #Object,
	#instVars : [
		'groupedData',
		'x',
		'y',
		'yTitle'
	],
	#category : #'IllimaniAllocationProfiler-UI-Roassal'
}

{ #category : #initialization }
IllimaniDistributionForFinalization >> initialize [

	super initialize.
	self yTitle: 'deci seconds'
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

	chart xlabel:  yTitle.
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

	yTitle := aString
]

{ #category : #api }
IllimaniDistributionForFinalization >> x: col [

	x := col
]

{ #category : #api }
IllimaniDistributionForFinalization >> y: col [

	y := col
]

{ #category : #api }
IllimaniDistributionForFinalization >> yTitle: aTitle [

	yTitle := aTitle
]
