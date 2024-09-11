Class {
	#name : 'IllAnalyzerPlot',
	#superclass : 'Object',
	#instVars : [
		'analyzer'
	],
	#category : 'IllimaniUI',
	#package : 'IllimaniUI'
}

{ #category : 'accessing' }
IllAnalyzerPlot >> analyzer: anObject [

	analyzer := anObject
]

{ #category : 'as yet unclassified' }
IllAnalyzerPlot >> plot [

	| chart plot deathTimes ages shortLivedThreshold |
	deathTimes := analyzer objectAllocations collect: [ :illEphe |
		((illEphe finalizationTime - analyzer startTime) / analyzer totalTime) min: 1 ].
	ages := analyzer objectAllocations collect: [ :illEphe |
		(illEphe lifetime) / analyzer totalTime ].

	plot := RSScatterPlot new
		x: deathTimes y: ages;
		xlabel: 'Object time of death relative to total allocation';
		ylabel: 'Object age relative to total allocation';
		maxChartValueX: 1;
		yourself.

	shortLivedThreshold :=  ages max * 0.45.

	chart := RSCompositeChart new
		add: plot;
		add: (RSLinePlot new x: #(1 0) y: #(0 1); color: Color black);
		add: (RSLinePlot new x: {1 . 0} y: {0.05 . 0.05}; color: Color black);
		yourself.

	chart title: ''.
	^ chart
]
