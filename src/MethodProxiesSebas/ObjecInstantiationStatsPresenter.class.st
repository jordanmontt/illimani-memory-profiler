Class {
	#name : #ObjecInstantiationStatsPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'allocations'
	],
	#category : #MethodProxiesSebas
}

{ #category : #layout }
ObjecInstantiationStatsPresenter >> allocations: someAllocations [

	allocations := someAllocations
]

{ #category : #layout }
ObjecInstantiationStatsPresenter >> defaultLayout [

	^ SpGridLayout new
		  add: 'Classes that Create' at: 1 @ 1;
		  add: self numberOfClasses size asString at: 2 @ 1 span: 2 @ 1;
		  add: 'Methods that Create' at: 1 @ 2;
		  add: self numberOfMethods size asString at: 2 @ 2 span: 2 @ 1;
		  add: 'Total Instantiated Objects ' at: 1 @ 3;
		  add: self totalInstantiatedObjects size asString at: 2 @ 3 span: 2 @ 1;
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
