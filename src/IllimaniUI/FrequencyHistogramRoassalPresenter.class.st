Class {
	#name : 'FrequencyHistogramRoassalPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'data',
		'histogramPresenter'
	],
	#category : 'IllimaniUI-Roassal',
	#package : 'IllimaniUI',
	#tag : 'Roassal'
}

{ #category : 'adding' }
FrequencyHistogramRoassalPresenter >> addChartTitles: chart [

	chart xlabel: 'Relative execution time'.
	chart ylabel: 'Allocated objects'.
	chart title: 'Relative frequencies histogram'
]

{ #category : 'api' }
FrequencyHistogramRoassalPresenter >> buildFrequencyHistogramCanvas [

	| chart plot |
	chart :=	chart := RSCompositeChart new.
	plot := RSHistogramPlot new
		x: data;
		relativeVerticalTicks;
		yourself.
	chart add: plot.

	self addChartTitles: chart.
	chart build.
	^ chart canvas
]

{ #category : 'layout' }
FrequencyHistogramRoassalPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: histogramPresenter;
		  yourself
]

{ #category : 'initialization' }
FrequencyHistogramRoassalPresenter >> initializePresenters [

	histogramPresenter := SpRoassalPresenter new
		canvas: self buildFrequencyHistogramCanvas;
		yourself
]

{ #category : 'accessing - model' }
FrequencyHistogramRoassalPresenter >> setModelBeforeInitialization: aProfiler [

	| totalExecutionTime relativeLifetimes |
	totalExecutionTime := aProfiler totalTime.
	relativeLifetimes := aProfiler objectAllocations collect: [ :allocModel |
		(allocModel lifetime min: totalExecutionTime) / totalExecutionTime * 100 ].
	data := relativeLifetimes
]
