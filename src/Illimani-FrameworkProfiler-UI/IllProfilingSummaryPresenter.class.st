Class {
	#name : 'IllProfilingSummaryPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'profiler'
	],
	#category : 'Illimani-FrameworkProfiler-UI-Widgets',
	#package : 'Illimani-FrameworkProfiler-UI',
	#tag : 'Widgets'
}

{ #category : 'layout' }
IllProfilingSummaryPresenter >> buildTablePresenterOn: associations [ 

	^ self newTable
		addColumn: (SpStringTableColumn title: 'Name' evaluated: #key);
		addColumn: (SpStringTableColumn title: 'Value' evaluated: #value);
		items: associations;
		beResizable;
		yourself
]

{ #category : 'layout' }
IllProfilingSummaryPresenter >> defaultLayout [

	| gcReport generalStatsTable | 
	generalStatsTable := self buildTablePresenterOn: self generalStatsAssociations. 

	gcReport := self newText
		text: profiler reportVMStats;
		beNotEditable;
		yourself.

	^ SpPanedLayout newTopToBottom
		add: (SpBoxLayout newTopToBottom
			add: 'General Statistics' expand: false;
			add: generalStatsTable;
			yourself );
		add: gcReport;
		positionOfSlider: 0.35;
		yourself
]

{ #category : 'layout' }
IllProfilingSummaryPresenter >> generalStatsAssociations [

	^ {
		('Total profiled time' -> profiler totalTime humanReadableByteSizeString).
		('Sampling rate' -> self samplingRateString).
		('Profiled code' -> profiler profiledCode) }
]

{ #category : 'layout' }
IllProfilingSummaryPresenter >> samplingRateString [

	^ String streamContents: [ :stream |
		  profiler samplingRate * 100
			  printOn: stream
			  showingDecimalPlaces: 1.
		  stream << ' %' ]
]

{ #category : 'accessing - model' }
IllProfilingSummaryPresenter >> setModelBeforeInitialization: aModel [

	profiler := aModel
]
