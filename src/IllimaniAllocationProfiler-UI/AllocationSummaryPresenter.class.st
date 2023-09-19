"
I am a presenter class that shows basic statistics about the object allocations.
"
Class {
	#name : 'AllocationSummaryPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'profiler'
	],
	#category : 'IllimaniAllocationProfiler-UI-Widgets',
	#package : 'IllimaniAllocationProfiler-UI',
	#tag : 'Widgets'
}

{ #category : 'layout' }
AllocationSummaryPresenter >> defaultLayout [

	| gcElements generalStatsElements tablePresenter tablePresenter2 |
	generalStatsElements := {
		'Total profiled time' -> self totalProfiledTime .
		'Time difference between first and last allocation' -> self timeDifferenceBetweenFirstAndLastAllocation .
		'Total allocated objects' -> self totalAllocatedObjects .
		'Total allocated memory' -> self totalAllocatedMemory .
		'Classes that allocate objects' -> self numberOfClasses .
		'Methods that allocate objects' -> self numberOfMethods .
		 }.

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
AllocationSummaryPresenter >> fullGCCount [

	^ profiler fullGCCount asString
]

{ #category : 'accessing' }
AllocationSummaryPresenter >> incrementalGCCount [

	^ profiler incrementalGCCount asString
]

{ #category : 'accessing' }
AllocationSummaryPresenter >> numberOfClasses [

	^ profiler stats numberOfClasses asString
]

{ #category : 'accessing' }
AllocationSummaryPresenter >> numberOfMethods [

	^ profiler stats numberOfMethods asString
]

{ #category : 'accessing - model' }
AllocationSummaryPresenter >> setModelBeforeInitialization: aModel [

	profiler := aModel
]

{ #category : 'accessing' }
AllocationSummaryPresenter >> timeDifferenceBetweenFirstAndLastAllocation [

	^ (Duration microSeconds: profiler stats timeDifferenceBetweenFirstAndLastAllocation)
		  humanReadableStringWithOnlySeconds
]

{ #category : 'accessing' }
AllocationSummaryPresenter >> totalAllocatedMemory [

	^ profiler stats totalAllocatedMemory humanReadableByteSizeString
]

{ #category : 'accessing' }
AllocationSummaryPresenter >> totalAllocatedObjects [

	^ profiler stats totalAllocatedObjects asStringWithCommas
]

{ #category : 'accessing' }
AllocationSummaryPresenter >> totalGCTime [

	^ profiler totalGCTime asDuration humanReadableStringWithOnlySeconds
]

{ #category : 'accessing' }
AllocationSummaryPresenter >> totalProfiledTime [

	^ (Duration microSeconds: profiler totalProfiledTime) humanReadableStringWithOnlySeconds
]
