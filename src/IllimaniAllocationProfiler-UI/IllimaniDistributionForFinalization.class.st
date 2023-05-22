Class {
	#name : #IllimaniDistributionForFinalization,
	#superclass : #Object,
	#instVars : [
		'x',
		'y',
		'yTitle',
		'xTitle',
		'title'
	],
	#category : #'IllimaniAllocationProfiler-UI-Roassal'
}

{ #category : #api }
IllimaniDistributionForFinalization >> addMarks: chart [

	| marker90Percent markerColor marker10Percent |
	markerColor := Color fromHexString: '922724'.

	chart addDecoration: (marker90Percent := RSXMarkerDecoration new
			                    sumUpTo: 0.9;
			                    color: markerColor;
			                    yourself).
	"chart addDecoration: (marker10Percent := RSXMarkerDecoration new
			                    sumUpTo: 0.1;
			                    color: markerColor;
			                    yourself)."
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

"	marker10Percent lines do: [ :line |
		| label |
		label := RSLabel new
			         text: '10%';
			         color: markerColor;
			         fontSize: 6;
			         yourself.
		RSLocation new
			above;
			move: label on: line.
		chart canvas add: label ]"
]

{ #category : #initialization }
IllimaniDistributionForFinalization >> initialize [

	super initialize.
	self xTitle: 'Lifetime in seconds'.
	self yTitle: 'Memory'.
	title := 'Bench 500 MB capturing allocations'.
	
]

{ #category : #api }
IllimaniDistributionForFinalization >> palu4 [

	| chart plot markerColor marker |
	chart := RSChart new.

	plot := RSLinePlot new
		color: (Color fromHexString: '#CD5C5C');
		x: x y: y.

	chart addPlot: plot.

	chart addDecoration: (RSHorizontalTick new
			 numberOfTicks: 10;
			 labelConversion: [ :e | e asInteger printString ];
			 yourself).
	chart addDecoration: (RSVerticalTick new
			 numberOfTicks: 10;
			 labelConversion: [ :e | e asInteger humanReadableByteSizeString "asStringWithCommas"];
			 yourself).

	markerColor := Color blue.
	chart addDecoration: (marker := RSXMarkerDecoration new
		sumUpTo: 0.6"0.75";
		color: markerColor;
		width: 0.6;
		yourself). 

	chart yLog.

	chart minValueX: -1.

	chart xlabel:  xTitle.
	chart ylabel: yTitle.
	chart title: title.

	chart build.
	
	marker lines do: [ :line |
		| label |
		label := RSLabel new
			         "text: '75%';" text: '60%';
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

	xTitle := aString
]

{ #category : #api }
IllimaniDistributionForFinalization >> title: aTitle [

	title := aTitle
]

{ #category : #api }
IllimaniDistributionForFinalization >> x: col [

	x := col
]

{ #category : #api }
IllimaniDistributionForFinalization >> xTitle: aTitle [

	xTitle := aTitle
]

{ #category : #api }
IllimaniDistributionForFinalization >> y: col [

	y := col
]

{ #category : #api }
IllimaniDistributionForFinalization >> yTitle: aTitle [

	yTitle := aTitle
]
