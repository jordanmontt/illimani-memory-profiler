Class {
	#name : 'AllocatedObjectsTablePresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'tablePresenter',
		'totalAllocations',
		'inputPresenter',
		'objectAllocations'
	],
	#category : 'IllimaniUI-Widgets',
	#package : 'IllimaniUI',
	#tag : 'Widgets'
}

{ #category : 'initialization' }
AllocatedObjectsTablePresenter >> connectPresenters [

	inputPresenter whenTextChangedDo: [ :text | self filterTable: text ].
	tablePresenter whenSelectedDo: [ :item | item value inspect ]
]

{ #category : 'layout' }
AllocatedObjectsTablePresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		spacing: 5;
		add: tablePresenter;
		add: inputPresenter expand: false;
		yourself
]

{ #category : 'accessing - model' }
AllocatedObjectsTablePresenter >> filterTable: aText [

	| newItems |
	aText ifEmpty: [
		tablePresenter items: objectAllocations.
		^ self ].
	newItems := objectAllocations select: [ :item |
		item value asString includesSubstring: aText caseSensitive: false ].
	tablePresenter items: newItems
]

{ #category : 'initialization' }
AllocatedObjectsTablePresenter >> initializePresenters [

	inputPresenter := self newTextInput
		placeholder: 'Filter';
		yourself.
	tablePresenter := self newTable
		alternateRowsColor;
		activateOnSingleClick;
		addColumn: (SpIndexTableColumn new
			title: 'Index';
			width: 60;
			yourself);
		addColumn: (SpStringTableColumn
			title: 'Allocated object class'
			evaluated: #key);
		addColumn: (SpStringTableColumn
			title: 'Allocations'
			evaluated: [ :e | e value size asStringWithCommas ]);
		addColumn: (SpStringTableColumn
			title: '%'
			evaluated: [:e |
				(((e value size / totalAllocations) * 100) asFloat printShowingDecimalPlaces: 2) , '%']);
		items: objectAllocations;
		yourself
]

{ #category : 'accessing - model' }
AllocatedObjectsTablePresenter >> setModelBeforeInitialization: allocations [

	objectAllocations := Dictionary new.
	allocations do: [ :e |
		objectAllocations
			at: e allocatedObjectClass
			update: [ :collection | collection add: e; yourself ]
			initial: [ OrderedCollection with: e ] ].
	objectAllocations := objectAllocations associations sorted: [ :a :b | a value size > b value size ].
	totalAllocations := allocations size
]
