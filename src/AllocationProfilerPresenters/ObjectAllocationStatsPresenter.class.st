"
I am a presenter class that shows basic statistics about the object allocations.
"
Class {
	#name : #ObjectAllocationStatsPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'allocations',
		'numberOfClassesLabel',
		'numberOfMethodsLabel',
		'totalAllocatedObjectsLabel',
		'totalUniqueAllocatedObjectsLabel',
		'statsModel'
	],
	#category : #AllocationProfilerPresenters
}

{ #category : #accessing }
ObjectAllocationStatsPresenter >> allocations: someAllocations [

	allocations := someAllocations
]

{ #category : #layout }
ObjectAllocationStatsPresenter >> defaultLayout [

	^ SpGridLayout new
		add: 'Classes that allocate objects: ' at: 1 @ 1;
		add: numberOfClassesLabel at: 2 @ 1 span: 2 @ 1;
		add: 'Methods that allocate objects: ' at: 1 @ 2;
		add: numberOfMethodsLabel at: 2 @ 2 span: 2 @ 1;
		add: 'Total allocated objects: ' at: 1 @ 3;
		add: totalAllocatedObjectsLabel at: 2 @ 3 span: 2 @ 1;
		add: 'Total unique allocated objects: ' at: 1 @ 4;
		add: totalUniqueAllocatedObjectsLabel at: 2 @ 4 span: 2 @ 1;
		beColumnNotHomogeneous;
		yourself
]

{ #category : #initialization }
ObjectAllocationStatsPresenter >> initializePresenters [

	numberOfClassesLabel := self newLabel
		label: self numberOfClasses asString;
		yourself.

	numberOfMethodsLabel := self newLabel
		label: self numberOfMethods asString;
		yourself.

	totalAllocatedObjectsLabel := self newLabel
		label: self totalAllocatedObjects asString;
		yourself.

	totalUniqueAllocatedObjectsLabel := self newLabel
		label: self totalUniqueAllocatedObjects asString;
		yourself
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
ObjectAllocationStatsPresenter >> totalUniqueAllocatedObjects [

	^ statsModel totalUniqueAllocatedObjects
]
