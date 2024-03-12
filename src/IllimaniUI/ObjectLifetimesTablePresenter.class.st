Class {
	#name : 'ObjectLifetimesTablePresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'tablePresenter',
		'totalAllocations',
		'inputPresenter',
		'totalLifetime',
		'groupedAllocations',
		'totalMemory'
	],
	#category : 'IllimaniUI-Widgets',
	#package : 'IllimaniUI',
	#tag : 'Widgets'
}

{ #category : 'initialization' }
ObjectLifetimesTablePresenter >> connectPresenters [

	inputPresenter whenTextChangedDo: [ :text | self filterTable: text ]
]

{ #category : 'layout' }
ObjectLifetimesTablePresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		spacing: 5;
		add: tablePresenter;
		add: inputPresenter expand: false;
		yourself
]

{ #category : 'accessing - model' }
ObjectLifetimesTablePresenter >> filterTable: aText [

	| newItems |
	aText ifEmpty: [
		tablePresenter items: groupedAllocations.
		^ self ].
	newItems := groupedAllocations select: [ :item |
		item first asString includesSubstring: aText caseSensitive: false ].
	tablePresenter items: newItems
]

{ #category : 'initialization' }
ObjectLifetimesTablePresenter >> initializePresenters [

	inputPresenter := self newTextInput
		placeholder: 'Filter';
		yourself.
	self initializeTablePresenter
]

{ #category : 'initialization' }
ObjectLifetimesTablePresenter >> initializeTablePresenter [

	tablePresenter := self newTable.
	tablePresenter
		alternateRowsColor;
		addColumn: (SpIndexTableColumn new
				 title: 'Index';
				 width: 60;
				 yourself);
		addColumn: (SpStringTableColumn title: 'Allocated object class' evaluated: #first);
		addColumn: (SpStringTableColumn
				title: '% Lifetime'
				evaluated: [ :e | self toPrettyPercentage: e third ]);
		addColumn: (SpStringTableColumn
				title: '% Allocations'
				evaluated: [ :e | self toPrettyPercentage: e second ]);
		addColumn: (SpStringTableColumn
				title: '% Memory'
				evaluated: [ :e | self toPrettyPercentage: e fourth ]);
		items: groupedAllocations
]

{ #category : 'initialization' }
ObjectLifetimesTablePresenter >> relativeAllocationsFor: assoc [

	^ (assoc value size / totalAllocations)* 100
]

{ #category : 'initialization' }
ObjectLifetimesTablePresenter >> relativeLifetimeFor: assoc [

	| relativeLifetimes |
	relativeLifetimes := assoc value collect: [ :e | e finalizationTime - e initializationTime ].
	relativeLifetimes := relativeLifetimes collect: [ :e | 
		e >= totalLifetime ifTrue: [ 100 ] ifFalse: [ (e / totalLifetime) * 100 ]].
	^ relativeLifetimes average
]

{ #category : 'initialization' }
ObjectLifetimesTablePresenter >> relativeMemoryFor: assoc [

	| totalGroupMemory |
	totalGroupMemory := assoc value sum: [ :e | e sizeInBytes ].
	^ totalGroupMemory / totalMemory * 100
]

{ #category : 'accessing - model' }
ObjectLifetimesTablePresenter >> setModelBeforeInitialization: aProfiler [

	| objectAllocations |
	totalAllocations := aProfiler objectAllocations size.
	totalLifetime := aProfiler totalTime.
	totalMemory := aProfiler objectAllocations sum: #sizeInBytes.
	
	objectAllocations := (aProfiler objectAllocations groupedBy: #allocatedObjectClass) associations.
	groupedAllocations := objectAllocations collect: [ : assoc |
		{ assoc key.
		self relativeAllocationsFor: assoc.
		self relativeLifetimeFor: assoc.
		self relativeMemoryFor: assoc } 
		 ].
	groupedAllocations sort: [ :a :b | a second > b second ]
]

{ #category : 'initialization' }
ObjectLifetimesTablePresenter >> toPrettyPercentage: percentage [

	^ (percentage asFloat printShowingDecimalPlaces: 2) , '%'
]
