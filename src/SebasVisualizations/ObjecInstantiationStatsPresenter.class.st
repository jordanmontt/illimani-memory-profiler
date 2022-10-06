Class {
	#name : #ObjecInstantiationStatsPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'allocations',
		'numberOfClassesLabel',
		'numberOfMethodsLabel',
		'totalInstantiatedObjectLabel',
		'totalUniqueInstantiatedObjectsLabal'
	],
	#category : #SebasVisualizations
}

{ #category : #layout }
ObjecInstantiationStatsPresenter >> allocations: someAllocations [

	allocations := someAllocations
]

{ #category : #layout }
ObjecInstantiationStatsPresenter >> defaultLayout [

	^ SpGridLayout new
		add: 'Classes that create objects' at: 1 @ 1;
		add: numberOfClassesLabel at: 2 @ 1 span: 2 @ 1;
		add: 'Methods that create objects' at: 1 @ 2;
		add: numberOfMethodsLabel at: 2 @ 2 span: 2 @ 1;
		add: 'Total instantiated objects ' at: 1 @ 3;
		add: totalInstantiatedObjectLabel at: 2 @ 3 span: 2 @ 1;
		add: 'Total unique instantiated objects ' at: 1 @ 4;
		add: totalUniqueInstantiatedObjectsLabal at: 2 @ 4 span: 2 @ 1;
		beColumnNotHomogeneous;
		yourself
]

{ #category : #initialization }
ObjecInstantiationStatsPresenter >> initializePresenters [

	numberOfClassesLabel := self newLabel
		label: self numberOfClasses size asString;
		yourself.

	numberOfMethodsLabel := self newLabel
		label: self numberOfMethods size asString;
		yourself.

	totalInstantiatedObjectLabel := self newLabel
		label: self totalInstantiatedObjects size asString;
		yourself.

	totalUniqueInstantiatedObjectsLabal := self newLabel
		label: self totalUniqueInstantiatedObjects size asString;
		yourself
]

{ #category : #layout }
ObjecInstantiationStatsPresenter >> numberOfClasses [

	^ (allocations collect: [ :e | e context methodClass ]) asSet
]

{ #category : #layout }
ObjecInstantiationStatsPresenter >> numberOfMethods [

	^ (allocations collect: [ :e | e context asString ]) asSet
]

{ #category : #'accessing - model' }
ObjecInstantiationStatsPresenter >> setModelBeforeInitialization: someAllocations [

	allocations := someAllocations
]

{ #category : #layout }
ObjecInstantiationStatsPresenter >> totalInstantiatedObjects [

	^ allocations
]

{ #category : #layout }
ObjecInstantiationStatsPresenter >> totalUniqueInstantiatedObjects [

	^ (allocations collect: [ :a | a createdObject ]) asSet
]
