Class {
	#name : 'IllimaniDensityDistributionChart',
	#superclass : 'Object',
	#instVars : [
		'yTitle',
		'xTitle',
		'title',
		'numberOfTicks',
		'groupedDataBySeconds',
		'isForMemory',
		'x'
	],
	#category : 'IllimaniAllocationProfiler-UI-Roassal',
	#package : 'IllimaniAllocationProfiler-UI',
	#tag : 'Roassal'
}

{ #category : 'defaults' }
IllimaniDensityDistributionChart >> addChartTitles: chart [

	chart xlabel: xTitle.
	chart ylabel: yTitle.
	chart title: title
]

{ #category : 'defaults' }
IllimaniDensityDistributionChart >> addTickDecorations: chart [

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
IllimaniDensityDistributionChart >> beForMemory [

	isForMemory := true
]

{ #category : 'api' }
IllimaniDensityDistributionChart >> beForNumberOfAllocations [

	isForMemory := false
]

{ #category : 'defaults' }
IllimaniDensityDistributionChart >> dataByMemory [

	| dictionary |
	dictionary := Dictionary newFrom: groupedDataBySeconds.
	^ x collect: [ :index |
		  dictionary at: index
			  ifPresent: [ :collection | collection sum: [ :e | e totalSizeInBytes ] ]
			  ifAbsent: [ 0 ] ]
]

{ #category : 'defaults' }
IllimaniDensityDistributionChart >> dataByNumberOfAllocations [

	| dictionary |
	dictionary := Dictionary newFrom: groupedDataBySeconds.
	^ x collect: [ :index |
		  dictionary at: index ifPresent: [ :collection | collection size ] ifAbsent: [ 0 ] ]
]

{ #category : 'api' }
IllimaniDensityDistributionChart >> densityChartCanvas [

	| plot y chart |
	chart := self initializeChart.
	y := isForMemory ifTrue: [ self dataByMemory ] ifFalse: [ self dataByNumberOfAllocations ].
	plot := RSLinePlot new
		color: (Color fromHexString: '#CD5C5C');
		x: x y: y.
	
	chart add: plot.
	"marker := RSXMarkerDecoration new
		sumUpTo: 0.6 ""0.75"";
		color: Color blue;
		width: 0.6;
		yourself.
	chart addDecoration: marker."
	self addTickDecorations: chart.
	chart minChartValueX: -1.
	self addChartTitles: chart.
	chart yLog.
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
IllimaniDensityDistributionChart >> densityChartPresenter [

	^ SpRoassalPresenter new
		  canvas: self densityChartCanvas;
		  yourself
]

{ #category : 'initialization' }
IllimaniDensityDistributionChart >> initialize [

	super initialize.

	xTitle := ''.
	yTitle := ''.
	title := ''.
	numberOfTicks := 10.
	isForMemory := true
]

{ #category : 'initialization' }
IllimaniDensityDistributionChart >> initializeChart [

	^ RSCompositeChart new
		colors: NSScale google20;
		yourself
]

{ #category : 'api' }
IllimaniDensityDistributionChart >> numberOfTicks: anInteger [

	numberOfTicks := anInteger
]

{ #category : 'api' }
IllimaniDensityDistributionChart >> objectAllocations: someObjectAllocations [

	groupedDataBySeconds := (someObjectAllocations groupedBy: [ :allocationModel |
		allocationModel lifetimeAsDuration asSeconds ]) associations.
	groupedDataBySeconds sort: [ :a :b | a key < b key ].
	x := 0 to: groupedDataBySeconds last key asInteger.
]

{ #category : 'api' }
IllimaniDensityDistributionChart >> title: aTitle [

	title := aTitle
]

{ #category : 'api' }
IllimaniDensityDistributionChart >> xTitle: aTitle [

	xTitle := aTitle
]

{ #category : 'api' }
IllimaniDensityDistributionChart >> yTitle: aTitle [

	yTitle := aTitle
]
