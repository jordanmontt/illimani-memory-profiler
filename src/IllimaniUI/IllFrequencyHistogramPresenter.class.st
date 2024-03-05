Class {
	#name : 'IllFrequencyHistogramPresenter',
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
IllFrequencyHistogramPresenter >> addChartTitles: chart [

	chart xlabel: 'Relative execution time'.
	chart ylabel: 'Percent'.
	chart title: 'Relative frequencies histogram'
]

{ #category : 'api' }
IllFrequencyHistogramPresenter >> buildFrequencyHistogramCanvas [

	| chart plot |
	chart :=	chart := RSCompositeChart new.
	plot := RSHistogramPlot new x: data.
	chart add: plot.

	self addChartTitles: chart.
	chart build.
	^ chart canvas
]

{ #category : 'layout' }
IllFrequencyHistogramPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: histogramPresenter;
		  yourself
]

{ #category : 'initialization' }
IllFrequencyHistogramPresenter >> initializePresenters [

	histogramPresenter := SpRoassalPresenter new
		canvas: self buildFrequencyHistogramCanvas;
		yourself
]

{ #category : 'accessing - model' }
IllFrequencyHistogramPresenter >> setModelBeforeInitialization: aProfiler [

	| totalExecutionTime relativeLifetimes |
	totalExecutionTime := aProfiler totalTime.
	relativeLifetimes := aProfiler objectAllocations collect: [ :allocModel |
		(allocModel lifetime min: totalExecutionTime) / totalExecutionTime * 100 ].
	data := relativeLifetimes
]
