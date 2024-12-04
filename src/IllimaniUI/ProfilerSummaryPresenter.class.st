Class {
	#name : 'ProfilerSummaryPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'profiler'
	],
	#category : 'IllimaniUI-Widgets',
	#package : 'IllimaniUI',
	#tag : 'Widgets'
}

{ #category : 'layout' }
ProfilerSummaryPresenter >> buildTablePresenterOn: associations [ 

	^ self newTable
		addColumn: (SpStringTableColumn title: 'Name' evaluated: #key);
		addColumn: (SpStringTableColumn title: 'Value' evaluated: #value);
		items: associations;
		beResizable;
		yourself
]

{ #category : 'layout' }
ProfilerSummaryPresenter >> defaultLayout [

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
ProfilerSummaryPresenter >> generalStatsAssociations [

	^ {
		('Total profiled time' -> profiler totalTime humanReadableByteSizeString).
		('Total allocated objects' -> profiler allocationStats totalAllocations asStringWithCommas).
		('Total allocated memory' ->
			profiler allocationStats totalAllocatedMemory humanReadableByteSizeString).
		('Sampling rate' -> self samplingRateString).
		('Profiled code' -> profiler profiledCode).
		('Total allocator methods' -> profiler allocationStats numberOfAllocationSites asString) }
]

{ #category : 'layout' }
ProfilerSummaryPresenter >> samplingRateString [

	^ String streamContents: [ :stream |
		  profiler samplingRate * 100
			  printOn: stream
			  showingDecimalPlaces: 1.
		  stream << ' %' ]
]

{ #category : 'accessing - model' }
ProfilerSummaryPresenter >> setModelBeforeInitialization: aModel [

	profiler := aModel
]
