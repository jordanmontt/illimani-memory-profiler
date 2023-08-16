Class {
	#name : #IllimaniDensityDistributionChart,
	#superclass : #Object,
	#instVars : [
		'x',
		'y',
		'yTitle',
		'xTitle',
		'title',
		'numberOfTicks',
		'chart',
		'isMemoryChart'
	],
	#category : #'IllimaniAllocationProfiler-UI-Roassal'
}

{ #category : #defaults }
IllimaniDensityDistributionChart >> addChartTitles [

	chart xlabel: xTitle.
	chart ylabel: yTitle.
	chart title: title
]

{ #category : #defaults }
IllimaniDensityDistributionChart >> addTickDecorations [

	"Horizonral tick is always the same"
	chart horizontalTick
		numberOfTicks: numberOfTicks;
		labelConversion: [ :e | e asInteger printString ].

	chart verticalTick numberOfTicks: numberOfTicks.
	isMemoryChart 
		ifTrue: [
			chart verticalTick labelConversion: [ :e | e asInteger humanReadableByteSizeString ] ]
		ifFalse: [ 
			chart verticalTick labelConversion: [ :e | e asInteger asStringWithCommas ] ]
]

{ #category : #api }
IllimaniDensityDistributionChart >> densityChartCanvas [

	| plot |
	plot := RSLinePlot new
		color: (Color fromHexString: '#CD5C5C');
		x: x y: y.
	chart add: plot.
	"markerColor := Color blue.
	chart addDecoration: (marker := RSXMarkerDecoration new
		sumUpTo: 0.6""0.75"";
		color: markerColor;
		width: 0.6;
		yourself). "
	
	self addTickDecorations.
	
	chart minChartValueX: -1.
	self addChartTitles.
	
	chart build.
	"marker lines do: [ :line |
		| label |
		label := RSLabel new
			         ""text: '75%';"" text: '60%';
			         color: markerColor;
			         fontSize: 6;
			         yourself.
		RSLocation new
			above;
			move: label on: line.
		chart canvas add: label ]."
	^ chart canvas
]

{ #category : #api }
IllimaniDensityDistributionChart >> densityChartPresenter [

	^ SpRoassalPresenter new
		  canvas: self densityChartCanvas;
		  yourself
]

{ #category : #initialization }
IllimaniDensityDistributionChart >> initialize [

	super initialize.
	chart := RSCompositeChart new.

	xTitle := ''.
	yTitle := ''.
	title := ''.
	numberOfTicks := 10.
	isMemoryChart := true
]

{ #category : #api }
IllimaniDensityDistributionChart >> isMemoryChart: aBoolean [

	isMemoryChart := aBoolean
]

{ #category : #api }
IllimaniDensityDistributionChart >> numberOfTicks: anInteger [

	numberOfTicks := anInteger
]

{ #category : #api }
IllimaniDensityDistributionChart >> title: aTitle [

	title := aTitle
]

{ #category : #api }
IllimaniDensityDistributionChart >> x: col [

	x := col
]

{ #category : #api }
IllimaniDensityDistributionChart >> xTitle: aTitle [

	xTitle := aTitle
]

{ #category : #api }
IllimaniDensityDistributionChart >> y: col [

	y := col
]

{ #category : #api }
IllimaniDensityDistributionChart >> yLog [

	chart yLog
]

{ #category : #api }
IllimaniDensityDistributionChart >> yTitle: aTitle [

	yTitle := aTitle
]
