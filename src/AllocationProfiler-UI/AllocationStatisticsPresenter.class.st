"
I am a presenter class that shows basic statistics about the object allocations.
"
Class {
	#name : #AllocationStatisticsPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'model'
	],
	#category : #'AllocationProfiler-UI'
}

{ #category : #layout }
AllocationStatisticsPresenter >> buildGridLayoutFor: layoutAssociations title: aTitle [

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
AllocationStatisticsPresenter >> defaultLayout [

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
AllocationStatisticsPresenter >> fullGCCount [

	^ model fullGCCount asString
]

{ #category : #accessing }
AllocationStatisticsPresenter >> incrementalGCCount [

	^ model incrementalGCCount asString
]

{ #category : #accessing }
AllocationStatisticsPresenter >> numberOfClasses [

	^ model stats numberOfClasses asString
]

{ #category : #accessing }
AllocationStatisticsPresenter >> numberOfMethods [

	^ model stats numberOfMethods asString
]

{ #category : #'accessing - model' }
AllocationStatisticsPresenter >> setModelBeforeInitialization: aModel [

	model := aModel
]

{ #category : #accessing }
AllocationStatisticsPresenter >> timeDifferenceBetweenFirstAndLastAllocation [

	^ model stats timeDifferenceBetweenFirstAndLastAllocation asDuration
		  humanReadableStringWithOnlySeconds
]

{ #category : #accessing }
AllocationStatisticsPresenter >> totalAllocatedObjects [

	^ model stats totalAllocatedObjects asString
]

{ #category : #accessing }
AllocationStatisticsPresenter >> totalEqualAllocatedObjects [

	| totalEqualAllocatedObjects |
	totalEqualAllocatedObjects := model stats totalEqualAllocatedObjects.

	^ totalEqualAllocatedObjects = 1
		ifTrue: [ '-' ]
		ifFalse: [ totalEqualAllocatedObjects asString ]
]

{ #category : #accessing }
AllocationStatisticsPresenter >> totalGCTime [

	^ model totalGCTime asDuration humanReadableStringWithOnlySeconds
]

{ #category : #accessing }
AllocationStatisticsPresenter >> totalProfiledTime [

	^ model totalProfiledTime asDuration humanReadableStringWithOnlySeconds
]
