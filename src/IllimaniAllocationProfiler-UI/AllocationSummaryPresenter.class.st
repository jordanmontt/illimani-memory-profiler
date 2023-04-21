"
I am a presenter class that shows basic statistics about the object allocations.
"
Class {
	#name : #AllocationSummaryPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'model'
	],
	#category : #'IllimaniAllocationProfiler-UI-Widgets'
}

{ #category : #layout }
AllocationSummaryPresenter >> defaultLayout [

	| gcElements generalStatsElements tablePresenter tablePresenter2 |
	generalStatsElements := {
		'Total profiled time' -> self totalProfiledTime .
		'Time difference between first and last allocation' -> self timeDifferenceBetweenFirstAndLastAllocation .
		'Total allocated objects' -> self totalAllocatedObjects .
		'Total equal allocated objects' -> self totalEqualAllocatedObjects .
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

{ #category : #accessing }
AllocationSummaryPresenter >> fullGCCount [

	^ model fullGCCount asString
]

{ #category : #accessing }
AllocationSummaryPresenter >> incrementalGCCount [

	^ model incrementalGCCount asString
]

{ #category : #accessing }
AllocationSummaryPresenter >> numberOfClasses [

	^ model stats numberOfClasses asString
]

{ #category : #accessing }
AllocationSummaryPresenter >> numberOfMethods [

	^ model stats numberOfMethods asString
]

{ #category : #'accessing - model' }
AllocationSummaryPresenter >> setModelBeforeInitialization: aModel [

	model := aModel
]

{ #category : #accessing }
AllocationSummaryPresenter >> timeDifferenceBetweenFirstAndLastAllocation [

	^ (Duration microSeconds: model stats timeDifferenceBetweenFirstAndLastAllocation)
		  humanReadableStringWithOnlySeconds
]

{ #category : #accessing }
AllocationSummaryPresenter >> totalAllocatedMemory [

	^ model stats totalAllocatedMemory humanReadableByteSizeString
]

{ #category : #accessing }
AllocationSummaryPresenter >> totalAllocatedObjects [

	^ model stats totalAllocatedObjects asStringWithCommas
]

{ #category : #accessing }
AllocationSummaryPresenter >> totalEqualAllocatedObjects [

	| totalEqualAllocatedObjects |
	totalEqualAllocatedObjects := model stats totalEqualAllocatedObjects.

	^ totalEqualAllocatedObjects = 1
		ifTrue: [ '-' ]
		ifFalse: [ totalEqualAllocatedObjects asString ]
]

{ #category : #accessing }
AllocationSummaryPresenter >> totalGCTime [

	^ model totalGCTime asDuration humanReadableStringWithOnlySeconds
]

{ #category : #accessing }
AllocationSummaryPresenter >> totalProfiledTime [

	^ (Duration microSeconds: model totalProfiledTime) humanReadableStringWithOnlySeconds
]
