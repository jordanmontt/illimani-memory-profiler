Class {
	#name : 'AllocatedObjectsTablePresenter',
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
		tablePresenter items: groupedAllocations.
		^ self ].
	newItems := groupedAllocations select: [ :item |
		item first asString includesSubstring: aText caseSensitive: false ].
	tablePresenter items: newItems
]

{ #category : 'initialization' }
AllocatedObjectsTablePresenter >> initializePresenters [

	inputPresenter := self newTextInput
		placeholder: 'Filter';
		yourself.
	self initializeTablePresenter
]

{ #category : 'initialization' }
AllocatedObjectsTablePresenter >> initializeTablePresenter [

	tablePresenter := self newTable.
	tablePresenter
		alternateRowsColor;
		activateOnSingleClick;
		addColumn: (SpIndexTableColumn new
				 title: 'Index';
				 width: 60;
				 yourself);
		addColumn: (SpStringTableColumn title: 'Allocated object class' evaluated: #key);
		addColumn: (SpStringTableColumn
				title: 'Avg. lifetimes'
				evaluated: [ :e | self toPrettyPercentage: (self relativeLifetimeFor: e) ]);
		addColumn: (SpStringTableColumn
				title: '% Allocations'
				evaluated: [ :e | self toPrettyPercentage: (self relativeAllocationsFor: e) ]);
		addColumn: (SpStringTableColumn
				title: '% Memory'
				evaluated: [ :e | self toPrettyPercentage: (self relativeMemoryFor: e) ]);
		items: groupedAllocations
]

{ #category : 'initialization' }
AllocatedObjectsTablePresenter >> relativeAllocationsFor: assoc [

	^ (assoc value size / totalAllocations)* 100
]

{ #category : 'initialization' }
AllocatedObjectsTablePresenter >> relativeLifetimeFor: assoc [

	| relativeLifetimes |
	relativeLifetimes := assoc value collect: [ :e | e lifetime ].
	relativeLifetimes := relativeLifetimes collect: [ :e | 
		e >= totalLifetime ifTrue: [ 100 ] ifFalse: [ (e / totalLifetime) * 100 ]].
	^ relativeLifetimes average
]

{ #category : 'initialization' }
AllocatedObjectsTablePresenter >> relativeMemoryFor: assoc [

	| totalGroupMemory |
	totalGroupMemory := assoc value sum: [ :e | e sizeInBytes ].
	^ totalGroupMemory / totalMemory * 100
]

{ #category : 'accessing - model' }
AllocatedObjectsTablePresenter >> setModelBeforeInitialization: aProfiler [

	totalAllocations := aProfiler objectAllocations size.
	totalLifetime := aProfiler totalTime.
	totalMemory := aProfiler objectAllocations sum: #sizeInBytes.
	
	groupedAllocations := (aProfiler objectAllocations groupedBy: #allocatedObjectClass) associations.
	groupedAllocations := groupedAllocations sort: [ :a :b | 
		(self relativeAllocationsFor: a) > (self relativeAllocationsFor: b) ]
	
]

{ #category : 'initialization' }
AllocatedObjectsTablePresenter >> toPrettyPercentage: percentage [

	^ (percentage asFloat printShowingDecimalPlaces: 2) , '%'
]
