Class {
	#name : 'IllDensityDistributionChartBuilder',
	#superclass : 'Object',
	#instVars : [
		'yTitle',
		'xTitle',
		'title',
		'numberOfTicks',
		'groupedDataBySeconds',
		'isForMemory',
		'x',
		'isYLog'
	],
	#category : 'IllimaniUI-Roassal',
	#package : 'IllimaniUI',
	#tag : 'Roassal'
}

{ #category : 'defaults' }
IllDensityDistributionChartBuilder >> addChartTitles: chart [

	| completeYTitle |
	chart xlabel: xTitle.
	completeYTitle := isYLog ifTrue: [ yTitle , ' (log scale)' ] ifFalse: [ yTitle ].
	chart ylabel: completeYTitle.
	chart title: title
]

{ #category : 'defaults' }
IllDensityDistributionChartBuilder >> addTickDecorations: chart [

	"Horizontal ticks are always the same"
	chart horizontalTick
		numberOfTicks: numberOfTicks;
		labelConversion: [ :e | e asInteger printString ].

	chart verticalTick numberOfTicks: numberOfTicks.
	isForMemory 
		ifTrue: [
			chart verticalTick labelConversion: [ :e | e asInteger humanReadableByteSizeString ] ]
		ifFalse: [ 
			chart verticalTick labelConversion: [ :e | e asInteger asStringWithCommas ] ]
]

{ #category : 'api' }
IllDensityDistributionChartBuilder >> beForMemory [

	isForMemory := true
]

{ #category : 'api' }
IllDensityDistributionChartBuilder >> beForNumberOfAllocations [

	isForMemory := false
]

{ #category : 'api' }
IllDensityDistributionChartBuilder >> buildDensityChartCanvas [

	| plot y chart |
	chart := self initializeChart.
	y := isForMemory ifTrue: [ self dataByMemory ] ifFalse: [ self dataByNumberOfAllocations ].
	plot := RSLinePlot new
		color: (Color fromHexString: '#CD5C5C');
		x: x y: y;
		yourself.

	chart add: plot.
	"marker := RSXMarkerDecoration new
		sumUpTo: 0.77 ""0.75"";
		color: Color blue;
		width: 0.6;
		yourself.
	chart addDecoration: marker."
	self addTickDecorations: chart.
	chart minChartValueX: -1.
	self addChartTitles: chart.
	
	isYLog ifTrue: [ chart yLog ].
	
	chart build.
	"marker lines do: [ :line |
		| label |
		label := RSLabel new
			""text: '75%';"" text: '60%';
			color: Color blue;
			fontSize: 6;
			yourself.
		RSLocation new
			above;
			move: label on: line.
		chart canvas add: label ]."
	^ chart canvas
]

{ #category : 'api' }
IllDensityDistributionChartBuilder >> buildDensityChartPresenter [

	^ SpRoassalPresenter new
		canvas: self buildDensityChartCanvas;
		yourself
]

{ #category : 'defaults' }
IllDensityDistributionChartBuilder >> dataByMemory [

	| dictionary |
	dictionary := Dictionary newFrom: groupedDataBySeconds.
	^ x collect: [ :index |
		  dictionary at: index
			  ifPresent: [ :collection | collection sum: [ :e | e sizeInBytes ] ]
			  ifAbsent: [ 0 ] ]
]

{ #category : 'defaults' }
IllDensityDistributionChartBuilder >> dataByNumberOfAllocations [

	| dictionary |
	dictionary := Dictionary newFrom: groupedDataBySeconds.
	^ x collect: [ :index |
		  dictionary at: index ifPresent: [ :collection | collection size ] ifAbsent: [ 0 ] ]
]

{ #category : 'initialization' }
IllDensityDistributionChartBuilder >> initialize [

	super initialize.

	xTitle := 'Lifetime in seconds'.
	yTitle := ''.
	title := ''.
	numberOfTicks := 10.
	isForMemory := true.
	isYLog := false
]

{ #category : 'initialization' }
IllDensityDistributionChartBuilder >> initializeChart [

	^ RSCompositeChart new
		colors: NSScale google20;
		yourself
]

{ #category : 'api' }
IllDensityDistributionChartBuilder >> numberOfTicks: anInteger [

	numberOfTicks := anInteger
]

{ #category : 'api' }
IllDensityDistributionChartBuilder >> objectAllocations: someObjectAllocations [

	groupedDataBySeconds := (someObjectAllocations groupedBy: [ :allocationModel |
		allocationModel lifetimeAsDuration asSeconds ]) associations.
	groupedDataBySeconds sort: [ :a :b | a key < b key ].
	x := 0 to: groupedDataBySeconds last key asInteger.
]

{ #category : 'api' }
IllDensityDistributionChartBuilder >> title: aTitle [

	title := aTitle
]

{ #category : 'api' }
IllDensityDistributionChartBuilder >> xTitle: aTitle [

	xTitle := aTitle
]

{ #category : 'api' }
IllDensityDistributionChartBuilder >> yLog: aBoolean [

	isYLog := aBoolean
]

{ #category : 'api' }
IllDensityDistributionChartBuilder >> yTitle: aTitle [

	yTitle := aTitle
]
