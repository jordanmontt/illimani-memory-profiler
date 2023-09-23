Class {
	#name : 'AllocationSummaryPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'profiler'
	],
	#category : 'IllimaniUI-Widgets',
	#package : 'IllimaniUI',
	#tag : 'Widgets'
}

{ #category : 'layout' }
AllocationSummaryPresenter >> buildTablePresenterOn: associations [ 

	^ self newTable
		addColumn: (SpStringTableColumn title: 'Name' evaluated: #key);
		addColumn: (SpStringTableColumn title: 'Value' evaluated: #value);
		items: associations;
		beResizable;
		yourself
]

{ #category : 'layout' }
AllocationSummaryPresenter >> defaultLayout [

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
		positionOfSlider: 0.33;
		yourself
]

{ #category : 'layout' }
AllocationSummaryPresenter >> generalStatsAssociations [

	^ {		('Total profiled time' -> (Duration microSeconds: profiler totalProfiledTime)
				humanReadableStringWithOnlySeconds).
			('Total allocated objects' -> profiler stats totalAllocatedObjects asStringWithCommas).
			('Total allocated memory' -> profiler stats
				totalAllocatedMemory humanReadableByteSizeString) }
]

{ #category : 'accessing - model' }
AllocationSummaryPresenter >> setModelBeforeInitialization: aModel [

	profiler := aModel
]
