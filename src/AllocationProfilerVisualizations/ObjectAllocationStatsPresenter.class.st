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
		'totalUniqueAllocatedObjectsLabal'
	],
	#category : #AllocationProfilerVisualizations
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
		add: totalUniqueAllocatedObjectsLabal at: 2 @ 4 span: 2 @ 1;
		beColumnNotHomogeneous;
		yourself
]

{ #category : #initialization }
ObjectAllocationStatsPresenter >> initializePresenters [

	numberOfClassesLabel := self newLabel
		label: self numberOfClasses size asString;
		yourself.

	numberOfMethodsLabel := self newLabel
		label: self numberOfMethods size asString;
		yourself.

	totalAllocatedObjectsLabel := self newLabel
		label: self totalAllocatedObjects size asString;
		yourself.

	totalUniqueAllocatedObjectsLabal := self newLabel
		label: self totalUniqueAllocatedObjects size asString;
		yourself
]

{ #category : #accessing }
ObjectAllocationStatsPresenter >> numberOfClasses [

	^ (allocations collect: [ :e | e context methodClass ]) asSet
]

{ #category : #accessing }
ObjectAllocationStatsPresenter >> numberOfMethods [

	^ (allocations collect: [ :e | e context asString ]) asSet
]

{ #category : #'accessing - model' }
ObjectAllocationStatsPresenter >> setModelBeforeInitialization: someAllocations [

	allocations := someAllocations
]

{ #category : #accessing }
ObjectAllocationStatsPresenter >> totalAllocatedObjects [

	^ allocations
]

{ #category : #accessing }
ObjectAllocationStatsPresenter >> totalUniqueAllocatedObjects [

	^ (allocations collect: [ :a | a createdObject ]) asSet
]
