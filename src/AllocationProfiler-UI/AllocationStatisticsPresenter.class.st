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

{ #category : #default }
AllocationStatisticsPresenter >> convertTimeToAReadableString: aBlock [

	| time |
	time := [ self convertTimestampToSecondsString: aBlock value ]
		on: Exception
		do: [ :e | 'No time available for the moment.' ].
	^ time
]

{ #category : #default }
AllocationStatisticsPresenter >> convertTimestampToSecondsString: aDateAndTime [

	^ ((aDateAndTime asNanoSeconds / (10 raisedTo: 9)) asFloat printShowingDecimalPlaces: 2)
	  , ' seconds'
]

{ #category : #layout }
AllocationStatisticsPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: self statsGridLayout;
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

{ #category : #layout }
AllocationStatisticsPresenter >> statsGridLayout [

	| layoutElements statsGridLayout |


	layoutElements := { 'Total profiled time: ' -> self totalProfiledTime .
		'Time difference between first and last allocation: ' -> self timeDifferenceBetweenFirstAndLastAllocation .
		'Classes that allocate objects: ' -> self numberOfClasses .
		'Methods that allocate objects: ' -> self numberOfMethods .
		'Total allocated objects: ' -> self totalAllocatedObjects .
		'Total equal allocated objects: ' -> self totalEqualAllocatedObjects .
		'Total GC time during profiling' -> self totalGCTime.
		'Incremental GC performed during profiling' -> self incrementalGCCount.
		'Full GC performed during profiling' -> self fullGCCount }.

	statsGridLayout := SpGridLayout new
		  beColumnNotHomogeneous;
		  yourself.

	layoutElements doWithIndex: [ :assoc :index |
		statsGridLayout
			add: assoc key at: 1 @ index;
			add: assoc value at: 2 @ index "span: 2 @ 1" ].

	^ statsGridLayout
]

{ #category : #accessing }
AllocationStatisticsPresenter >> timeDifferenceBetweenFirstAndLastAllocation [

	^ self convertTimeToAReadableString: [
		  model stats timeDifferenceBetweenFirstAndLastAllocation ]
]

{ #category : #accessing }
AllocationStatisticsPresenter >> totalAllocatedObjects [

	^ model stats totalAllocatedObjects asString
]

{ #category : #accessing }
AllocationStatisticsPresenter >> totalEqualAllocatedObjects [

	^ model stats totalEqualAllocatedObjects asString
]

{ #category : #accessing }
AllocationStatisticsPresenter >> totalGCTime [

	^ self convertTimestampToSecondsString: model totalGCTime
]

{ #category : #accessing }
AllocationStatisticsPresenter >> totalProfiledTime [

	^ self convertTimestampToSecondsString: model totalProfiledTime
]
