Class {
	#name : 'IllDensityDistributionChartBuilder',
	#superclass : 'Object',
	#instVars : [
		'yTitle',
		'xTitle',
		'title',
		'numberOfTicks',
		'data'
	],
	#category : 'IllimaniUI-Roassal',
	#package : 'IllimaniUI',
	#tag : 'Roassal'
}

{ #category : 'defaults' }
IllDensityDistributionChartBuilder >> addChartTitles: chart [

	chart xlabel: xTitle.
	chart ylabel: yTitle.
	chart title: title
]

{ #category : 'api' }
IllDensityDistributionChartBuilder >> buildDensityChartCanvas [

	| densityPlot chart |
	chart := self initializeChart.
	densityPlot := RSDensityPlot data: data.
	densityPlot color: (NSScale google20 scale: 1).

	chart add: densityPlot.
	
	self addChartTitles: chart.
	chart build.
	^ chart canvas
]

{ #category : 'api' }
IllDensityDistributionChartBuilder >> buildDensityChartPresenter [

	^ SpRoassalPresenter new
		canvas: self buildDensityChartCanvas;
		yourself
]

{ #category : 'initialization' }
IllDensityDistributionChartBuilder >> initialize [

	super initialize.

	xTitle := 'Execution time'.
	yTitle := 'Density'.
	title := 'KDE Density plot'
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
IllDensityDistributionChartBuilder >> objectAllocations: someObjectAllocations totalProfiledTime: totalTime [

	| helperDict |
	helperDict := (0 to: (totalTime / 1000000 "convert to seconds") asInteger)
		collect: [ :idx | idx -> 0] as: Dictionary.

	someObjectAllocations do: [ :e |
	helperDict
		at: ( e lifetime / 1000000 "convert to seconds") asInteger
		update: [ :count | count + 1 ] ].

	data := helperDict keysSortedSafely collect: [ :key | helperDict at: key ]
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
IllDensityDistributionChartBuilder >> yTitle: aTitle [

	yTitle := aTitle
]
