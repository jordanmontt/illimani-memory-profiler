Class {
	#name : #ObjecInstantiationStatsPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'allocations'
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
		add: self numberOfClasses size asString at: 2 @ 1 span: 2 @ 1;
		add: 'Methods that create objects' at: 1 @ 2;
		add: self numberOfMethods size asString at: 2 @ 2 span: 2 @ 1;
		add: 'Total instantiated objects ' at: 1 @ 3;
		add: self totalInstantiatedObjects size asString at: 2 @ 3 span: 2 @ 1;
		add: 'Total unique instantiated objects ' at: 1 @ 4;
		add: self totalUniqueInstantiatedObjects size asString at: 2 @ 4 span: 2 @ 1;
		beColumnNotHomogeneous;
		yourself
]

{ #category : #initialization }
ObjecInstantiationStatsPresenter >> initializePresenters [
]

{ #category : #layout }
ObjecInstantiationStatsPresenter >> numberOfClasses [

	^ (allocations collect: [ :e | e context methodClass ]) asSet
]

{ #category : #layout }
ObjecInstantiationStatsPresenter >> numberOfMethods [

	^ (allocations collect: [ :e | e context asString ]) asSet
]

{ #category : #layout }
ObjecInstantiationStatsPresenter >> totalInstantiatedObjects [

	^ allocations
]

{ #category : #layout }
ObjecInstantiationStatsPresenter >> totalUniqueInstantiatedObjects [

	^ (allocations collect: [ :a | a createdObject ]) asSet
]
