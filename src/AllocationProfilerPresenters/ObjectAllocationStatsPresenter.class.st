"
I am a presenter class that shows basic statistics about the object allocations.
"
Class {
	#name : #ObjectAllocationStatsPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'statsModel'
	],
	#category : #AllocationProfilerPresenters
}

{ #category : #layout }
ObjectAllocationStatsPresenter >> defaultLayout [

	^ SpGridLayout new
		add: 'Total profiled time: ' at: 1 @ 1;
		add: self totalProfiledTime at: 2 @ 1 span: 2 @ 1;
	
		add: 'Classes that allocate objects: ' at: 1 @ 2;
		add: self numberOfClasses at: 2 @ 2 span: 2 @ 1;
		
		add: 'Methods that allocate objects: ' at: 1 @ 3;
		add: self numberOfMethods at: 2 @ 3 span: 2 @ 1;
		
		add: 'Total allocated objects: ' at: 1 @ 4;
		add: self totalAllocatedObjects at: 2 @ 4 span: 2 @ 1;
		
		add: 'Total unique allocated objects: ' at: 1 @ 5;
		add: self totalUniqueAllocatedObjects at: 2 @ 5 span: 2 @ 1;
		
		beColumnNotHomogeneous;
		yourself
]

{ #category : #initialization }
ObjectAllocationStatsPresenter >> initializePresenters [
]

{ #category : #accessing }
ObjectAllocationStatsPresenter >> numberOfClasses [

	^ statsModel calculateNumberOfClasses
]

{ #category : #accessing }
ObjectAllocationStatsPresenter >> numberOfMethods [

	^ statsModel numberOfMethods
]

{ #category : #'accessing - model' }
ObjectAllocationStatsPresenter >> setModelBeforeInitialization: aModel [

	statsModel := aModel
]

{ #category : #accessing }
ObjectAllocationStatsPresenter >> totalAllocatedObjects [

	^ statsModel totalAllocatedObjects
]

{ #category : #accessing }
ObjectAllocationStatsPresenter >> totalProfiledTime [

	^ ((statsModel totalProfiledTime asNanoSeconds / (10 raisedTo: 9))
		asFloat printShowingDecimalPlaces: 2) , ' seconds'
]

{ #category : #accessing }
ObjectAllocationStatsPresenter >> totalUniqueAllocatedObjects [

	^ statsModel totalUniqueAllocatedObjects
]
