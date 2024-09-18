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

{ #category : 'api' }
IllAnalyzerPlot >> plot [

	| chart plot deathTimes ages shortLivedThreshold |
	deathTimes := analyzer objectAllocations collect: [ :illEphe |
		((illEphe finalizationTime - analyzer startTime) / analyzer totalTime) min: 1 ].
	ages := analyzer objectAllocations collect: [ :illEphe |
		(illEphe lifetime) / analyzer totalTime ].

	plot := RSScatterPlot new
		x: deathTimes y: ages;
		maxChartValueX: 1;
		yourself.

	shortLivedThreshold := (analyzer shortObjectsBin max: #lifetime) / analyzer totalTime.

	chart := RSCompositeChart new
		add: plot;
		add: (RSLinePlot new x: {plot maxValueX . 0} y: {0 . plot maxValueY}; color: Color black);
		add: (RSLinePlot new x: {plot maxValueX . 0} y: {shortLivedThreshold . shortLivedThreshold}; color: Color black);
		xlabel: 'Object time of death relative to total allocation';
		ylabel: 'Object age relative to total allocation';
		yourself.

	chart title: ''.
	^ chart
]
