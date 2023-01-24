"
I am a presenter class that shows basic statistics about the object allocations.
"
Class {
	#name : #ObjectAllocationStatsPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'statsModel',
		'codeEvaluator',
		'totalProfiledTimeLabel'
	],
	#category : #'AllocationProfiler-UI'
}

{ #category : #api }
ObjectAllocationStatsPresenter >> beEvaluatorForObject: anObject [

	codeEvaluator beForObject: anObject
]

{ #category : #default }
ObjectAllocationStatsPresenter >> convertTimeToAReadableString: aBlock [

	| time |
	time := [ self convertTimestampToSecondsString: aBlock value ]
		on: Exception
		do: [ :e | 'No time available for the moment.' ].
	^ time
]

{ #category : #default }
ObjectAllocationStatsPresenter >> convertTimestampToSecondsString: aDateAndTime [

	^ ((aDateAndTime asNanoSeconds / (10 raisedTo: 9)) asFloat printShowingDecimalPlaces: 2)
	  , ' seconds'
]

{ #category : #layout }
ObjectAllocationStatsPresenter >> defaultLayout [

	^ SpPanedLayout newTopToBottom
		  positionOfSlider: 0.7;
		  add: self statsGridLayout;
		  add: codeEvaluator;
		  yourself
]

{ #category : #initialization }
ObjectAllocationStatsPresenter >> initializePresenters [

	codeEvaluator := self newCode
		withoutLineNumbers;
		text: 'self objectAllocations';
		yourself.
	totalProfiledTimeLabel := self newLabel
]

{ #category : #accessing }
ObjectAllocationStatsPresenter >> numberOfClasses [

	^ statsModel numberOfClasses asString
]

{ #category : #accessing }
ObjectAllocationStatsPresenter >> numberOfMethods [

	^ statsModel numberOfMethods asString
]

{ #category : #'accessing - model' }
ObjectAllocationStatsPresenter >> setModelBeforeInitialization: aModel [

	statsModel := aModel
]

{ #category : #layout }
ObjectAllocationStatsPresenter >> statsGridLayout [

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
		  add: 'Total unique allocated objects: ' at: 1 @ 6;
		  add: self totalUniqueAllocatedObjects at: 2 @ 6 span: 2 @ 1;
		  beColumnNotHomogeneous;
		  yourself
]

{ #category : #accessing }
ObjectAllocationStatsPresenter >> timeDifferenceBetweenFirstAndLastAllocation [

	^ self convertTimeToAReadableString: [
		  statsModel timeDifferenceBetweenFirstAndLastAllocation ]
]

{ #category : #accessing }
ObjectAllocationStatsPresenter >> totalAllocatedObjects [

	^ statsModel totalAllocatedObjects asString
]

{ #category : #accessing }
ObjectAllocationStatsPresenter >> totalProfiledTime [

	^ totalProfiledTimeLabel
]

{ #category : #accessing }
ObjectAllocationStatsPresenter >> totalProfiledTime: aTimeInSeconds [

	totalProfiledTimeLabel label: (self convertTimestampToSecondsString: aTimeInSeconds)
]

{ #category : #accessing }
ObjectAllocationStatsPresenter >> totalProfiledTimeBlock: aBlock [

	totalProfiledTimeLabel label: (self convertTimeToAReadableString: aBlock)
]

{ #category : #accessing }
ObjectAllocationStatsPresenter >> totalUniqueAllocatedObjects [

	^ statsModel totalUniqueAllocatedObjects asString
]
