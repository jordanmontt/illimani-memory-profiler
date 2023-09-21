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

	| gcElements generalStatsElements tablePresenter tablePresenter2 |
	generalStatsElements := self generalStatsAssociations.

	tablePresenter := self newTable.
	tablePresenter
		addColumn: (SpStringTableColumn title: 'Name' evaluated: #key);
		addColumn: (SpStringTableColumn title: 'Value' evaluated: #value);
		items: generalStatsElements;
		beResizable.

	gcElements := {
		'Total GC time during profiling' -> self totalGCTime.
		'Incremental GC performed during profiling' -> self incrementalGCCount.
		'Full GC performed during profiling' -> self fullGCCount }.

	tablePresenter2 := self newTable.
	tablePresenter2
		addColumn: (SpStringTableColumn title: 'Name' evaluated: #key);
		addColumn: (SpStringTableColumn title: 'Value' evaluated: #value);
		items: gcElements;
		beResizable.

	^ SpBoxLayout newTopToBottom
		add: 'General Statistics' expand: false;
		add: tablePresenter;
		add: 'Garbage Collection Data' expand: false;
		add: tablePresenter2;
		yourself
]

{ #category : 'accessing' }
BasicAllocationSummaryPresenter >> fullGCCount [

	^ profiler fullGCCount asString
]

{ #category : 'layout' }
BasicAllocationSummaryPresenter >> generalStatsAssociations [

	^ {
		  ('Total profiled time' -> self totalProfiledTime).
		  ('Time difference between first and last allocation' -> self timeDifferenceBetweenFirstAndLastAllocation).
		  ('Total allocated objects' -> self totalAllocatedObjects).
		  ('Total allocated memory' -> self totalAllocatedMemory) }
]

{ #category : 'accessing' }
BasicAllocationSummaryPresenter >> incrementalGCCount [

	^ profiler incrementalGCCount asString
]

{ #category : 'accessing - model' }
BasicAllocationSummaryPresenter >> setModelBeforeInitialization: aModel [

	profiler := aModel
]

{ #category : 'accessing' }
BasicAllocationSummaryPresenter >> timeDifferenceBetweenFirstAndLastAllocation [

	^ (Duration microSeconds: profiler stats timeDifferenceBetweenFirstAndLastAllocation)
		  humanReadableStringWithOnlySeconds
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
BasicAllocationSummaryPresenter >> totalGCTime [

	^ profiler totalGCTime asDuration humanReadableStringWithOnlySeconds
]

{ #category : 'accessing' }
BasicAllocationSummaryPresenter >> totalProfiledTime [

	^ (Duration microSeconds: profiler totalProfiledTime) humanReadableStringWithOnlySeconds
]
