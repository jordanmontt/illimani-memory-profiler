Class {
	#name : 'IllDensityDistributionChart',
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
IllDensityDistributionChart >> addChartTitles: chart [

	| completeYTitle |
	chart xlabel: xTitle.
	completeYTitle := isYLog ifTrue: [ yTitle , ' (log scale)' ] ifFalse: [ yTitle ].
	chart ylabel: completeYTitle.
	chart title: title
]

{ #category : 'defaults' }
IllDensityDistributionChart >> addTickDecorations: chart [

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
IllDensityDistributionChart >> beForMemory [

	isForMemory := true
]

{ #category : 'api' }
IllDensityDistributionChart >> beForNumberOfAllocations [

	isForMemory := false
]

{ #category : 'defaults' }
IllDensityDistributionChart >> dataByMemory [

	| dictionary |
	dictionary := Dictionary newFrom: groupedDataBySeconds.
	^ x collect: [ :index |
		  dictionary at: index
			  ifPresent: [ :collection | collection sum: [ :e | e sizeInBytes ] ]
			  ifAbsent: [ 0 ] ]
]

{ #category : 'defaults' }
IllDensityDistributionChart >> dataByNumberOfAllocations [

	| dictionary |
	dictionary := Dictionary newFrom: groupedDataBySeconds.
	^ x collect: [ :index |
		  dictionary at: index ifPresent: [ :collection | collection size ] ifAbsent: [ 0 ] ]
]

{ #category : 'api' }
IllDensityDistributionChart >> densityChartCanvas [

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
IllDensityDistributionChart >> densityChartPresenter [

	^ SpRoassalPresenter new
		canvas: self densityChartCanvas;
		yourself
]

{ #category : 'initialization' }
IllDensityDistributionChart >> initialize [

	super initialize.

	xTitle := 'Lifetime in seconds'.
	yTitle := ''.
	title := ''.
	numberOfTicks := 10.
	isForMemory := true.
	isYLog := false
]

{ #category : 'initialization' }
IllDensityDistributionChart >> initializeChart [

	^ RSCompositeChart new
		colors: NSScale google20;
		yourself
]

{ #category : 'api' }
IllDensityDistributionChart >> numberOfTicks: anInteger [

	numberOfTicks := anInteger
]

{ #category : 'api' }
IllDensityDistributionChart >> objectAllocations: someObjectAllocations [

	groupedDataBySeconds := (someObjectAllocations groupedBy: [ :allocationModel |
		allocationModel lifetimeAsDuration asSeconds ]) associations.
	groupedDataBySeconds sort: [ :a :b | a key < b key ].
	x := 0 to: groupedDataBySeconds last key asInteger.
]

{ #category : 'api' }
IllDensityDistributionChart >> title: aTitle [

	title := aTitle
]

{ #category : 'api' }
IllDensityDistributionChart >> xTitle: aTitle [

	xTitle := aTitle
]

{ #category : 'api' }
IllDensityDistributionChart >> yLog: aBoolean [

	isYLog := aBoolean
]

{ #category : 'api' }
IllDensityDistributionChart >> yTitle: aTitle [

	yTitle := aTitle
]
