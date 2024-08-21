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
ProfilerSummaryPresenter >> allocatedMemoryRateString [

	^ profiler allocationsStats allocatedMemoryRatePerSecond asInteger humanReadableByteSizeString
	  , ' per second'
]

{ #category : 'layout' }
ProfilerSummaryPresenter >> allocationRateString [

	| rate |
	rate := profiler allocationsStats allocationRatePerSecond.
	^ rate asInteger asStringWithCommas , ' allocations per second'
]

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
		('Total profiled time' ->
			(Duration microSeconds: profiler totalProfiledTime) humanReadableStringWithOnlySeconds).
		('Sampling rate' -> profiler samplingRate asFloat asString).
		('Total allocated objects' -> profiler allocationsStats totalAllocatedObjects asStringWithCommas).
		('Allocations rate' -> self allocationRateString ).
		('Total allocated memory' ->
			profiler allocationsStats totalAllocatedMemory humanReadableByteSizeString).
		('Allocated memory rate' -> self allocatedMemoryRateString).
		('Profiled code' -> profiler profiledCode).
		('Classes that allocate objects' -> profiler allocationsStats numberOfAllocatorClasses asString).
		 ('Methods that allocate objects' -> profiler allocationsStats numberOfAllocatorMethods asString) }
]

{ #category : 'accessing - model' }
ProfilerSummaryPresenter >> setModelBeforeInitialization: aModel [

	profiler := aModel
]
