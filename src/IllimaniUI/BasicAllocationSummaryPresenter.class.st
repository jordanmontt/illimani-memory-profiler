Class {
	#name : 'BasicAllocationSummaryPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'profiler'
	],
	#category : 'IllimaniUI-Widgets',
	#package : 'IllimaniUI',
	#tag : 'Widgets'
}

{ #category : 'layout' }
BasicAllocationSummaryPresenter >> defaultLayout [

	| gcReport generalStatsElements tablePresenter |
	generalStatsElements := self generalStatsAssociations.

	tablePresenter := self newTable.
	tablePresenter
		addColumn: (SpStringTableColumn title: 'Name' evaluated: #key);
		addColumn: (SpStringTableColumn title: 'Value' evaluated: #value);
		items: generalStatsElements;
		beResizable.

	gcReport := self newText
		text: profiler reportVMStats;
		beNotEditable;
		yourself.
	
	"gcElements := {
		'Total GC time during profiling' -> self totalGCTime.
		'Incremental GC performed during profiling' -> self incrementalGCCount.
		'Full GC performed during profiling' -> self fullGCCount }.

	tablePresenter2 := self newTable.
	tablePresenter2
		addColumn: (SpStringTableColumn title: 'Name' evaluated: #key);
		addColumn: (SpStringTableColumn title: 'Value' evaluated: #value);
		items: gcReport;
		beResizable."

	^ SpPanedLayout newTopToBottom
		add: (SpBoxLayout newTopToBottom
			add: 'General Statistics' expand: false;
			add: tablePresenter;
			yourself );
		"add: 'Garbage Collection Data' expand: false;"
		add: gcReport;
		positionOfSlider: 0.25;
		yourself
]

{ #category : 'layout' }
BasicAllocationSummaryPresenter >> generalStatsAssociations [

	^ {
		  ('Total profiled time' -> self totalProfiledTime).
		  ('Total allocated objects' -> self totalAllocatedObjects).
		  ('Total allocated memory' -> self totalAllocatedMemory) }
]

{ #category : 'accessing - model' }
BasicAllocationSummaryPresenter >> setModelBeforeInitialization: aModel [

	profiler := aModel
]

{ #category : 'accessing' }
BasicAllocationSummaryPresenter >> totalAllocatedMemory [

	^ profiler stats totalAllocatedMemory humanReadableByteSizeString
]

{ #category : 'accessing' }
BasicAllocationSummaryPresenter >> totalAllocatedObjects [

	^ profiler stats totalAllocatedObjects asStringWithCommas
]

{ #category : 'accessing' }
BasicAllocationSummaryPresenter >> totalProfiledTime [

	^ (Duration microSeconds: profiler totalProfiledTime) humanReadableStringWithOnlySeconds
]
