"
I am a presenter class that shows basic statistics about the object allocations.
"
Class {
	#name : #AllocationStatisticsPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'statsModel',
		'totalProfiledTimeLabel'
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

{ #category : #initialization }
AllocationStatisticsPresenter >> initializePresenters [

	totalProfiledTimeLabel := self newLabel
]

{ #category : #accessing }
AllocationStatisticsPresenter >> numberOfClasses [

	^ statsModel numberOfClasses asString
]

{ #category : #accessing }
AllocationStatisticsPresenter >> numberOfMethods [

	^ statsModel numberOfMethods asString
]

{ #category : #'accessing - model' }
AllocationStatisticsPresenter >> setModelBeforeInitialization: aModel [

	statsModel := aModel
]

{ #category : #layout }
AllocationStatisticsPresenter >> statsGridLayout [

	^ SpGridLayout new
		  add: 'Total profiled time: ' at: 1 @ 1;
		  add: self totalProfiledTime at: 2 @ 1 span: 2 @ 1;
		  add: 'Time difference between first and last allocation: ' at: 1 @ 2;
		  add: self timeDifferenceBetweenFirstAndLastAllocation at: 2 @ 2 span: 2 @ 1;
		  add: 'Classes that allocate objects: ' at: 1 @ 3;
		  add: self numberOfClasses at: 2 @ 3 span: 2 @ 1;
		  add: 'Methods that allocate objects: ' at: 1 @ 4;
		  add: self numberOfMethods at: 2 @ 4 span: 2 @ 1;
		  add: 'Total allocated objects: ' at: 1 @ 5;
		  add: self totalAllocatedObjects at: 2 @ 5 span: 2 @ 1;
		  add: 'Total equal allocated objects: ' at: 1 @ 6;
		  add: self totalEqualAllocatedObjects at: 2 @ 6 span: 2 @ 1;
		  beColumnNotHomogeneous;
		  yourself
]

{ #category : #accessing }
AllocationStatisticsPresenter >> timeDifferenceBetweenFirstAndLastAllocation [

	^ self convertTimeToAReadableString: [
		  statsModel timeDifferenceBetweenFirstAndLastAllocation ]
]

{ #category : #accessing }
AllocationStatisticsPresenter >> totalAllocatedObjects [

	^ statsModel totalAllocatedObjects asString
]

{ #category : #accessing }
AllocationStatisticsPresenter >> totalEqualAllocatedObjects [

	^ statsModel totalEqualAllocatedObjects asString
]

{ #category : #accessing }
AllocationStatisticsPresenter >> totalProfiledTime [

	^ totalProfiledTimeLabel
]

{ #category : #accessing }
AllocationStatisticsPresenter >> totalProfiledTime: aTimeInSeconds [

	totalProfiledTimeLabel label: (self convertTimestampToSecondsString: aTimeInSeconds)
]

{ #category : #accessing }
AllocationStatisticsPresenter >> totalProfiledTimeBlock: aBlock [

	totalProfiledTimeLabel label: (self convertTimeToAReadableString: aBlock)
]
