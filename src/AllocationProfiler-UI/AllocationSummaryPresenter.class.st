"
I am a presenter class that shows basic statistics about the object allocations.
"
Class {
	#name : #AllocationSummaryPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'model'
	],
	#category : #'AllocationProfiler-UI-Widgets'
}

{ #category : #layout }
AllocationSummaryPresenter >> buildGridLayoutFor: layoutAssociations title: aTitle [

	| aGridLayout |
	aGridLayout := SpGridLayout new
		  beColumnNotHomogeneous;
		  yourself.

	layoutAssociations doWithIndex: [ :assoc :index |
		aGridLayout
			add: assoc key at: 1 @ index;
			add: assoc value at: 2 @ index span: 2 @ 1 ].

	^ SpBoxLayout newTopToBottom
		add: aTitle expand: false;
		add: aGridLayout;
		yourself
]

{ #category : #layout }
AllocationSummaryPresenter >> defaultLayout [

	| gcLayoutElements generalStatsLayoutElements generalStatsLayout gcLayout |
	generalStatsLayoutElements := {
		'Total profiled time: ' -> self totalProfiledTime .
		'Time difference between first and last allocation: ' -> self timeDifferenceBetweenFirstAndLastAllocation .
		'Classes that allocate objects:' -> self numberOfClasses .
		'Methods that allocate objects:' -> self numberOfMethods .
		'Total allocated objects:' -> self totalAllocatedObjects .
		'Total equal allocated objects:' -> self totalEqualAllocatedObjects }.
	generalStatsLayout := self buildGridLayoutFor: generalStatsLayoutElements title: 'General Statistics'.

	gcLayoutElements := {
		'Total GC time during profiling:' -> self totalGCTime.
		'Incremental GC performed during profiling:' -> self incrementalGCCount.
		'Full GC performed during profiling:' -> self fullGCCount }.
	gcLayout := self buildGridLayoutFor: gcLayoutElements title: 'Garbage Collection Data'.

	^ SpBoxLayout newTopToBottom
		add: generalStatsLayout;
		add: gcLayout;
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

	^ model stats timeDifferenceBetweenFirstAndLastAllocation asDuration
		  humanReadableStringWithOnlySeconds
]

{ #category : #accessing }
AllocationSummaryPresenter >> totalAllocatedObjects [

	^ model stats totalAllocatedObjects asString
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

	^ model totalProfiledTime asDuration humanReadableStringWithOnlySeconds
]
