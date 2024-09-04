Class {
	#name : 'AllocationsGroupedByTablePresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'tablePresenter',
		'totalMemory',
		'totalAllocations',
		'groupedAllocations'
	],
	#category : 'IllimaniUI-Widgets',
	#package : 'IllimaniUI',
	#tag : 'Widgets'
}

{ #category : 'initialization' }
AllocationsGroupedByTablePresenter >> connectPresenters [

	tablePresenter whenSelectedDo: [ :item | item value inspect ]
]

{ #category : 'initialization' }
AllocationsGroupedByTablePresenter >> convertToPercentageString: aNumber [

	^ (aNumber * 100 printShowingDecimalPlaces: 2) , '%'
]

{ #category : 'layout' }
AllocationsGroupedByTablePresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		add: tablePresenter;
		yourself
]

{ #category : 'accessing - model' }
AllocationsGroupedByTablePresenter >> groupAllocations: someObjectAllocations [

	^ self subclassResponsibility
]

{ #category : 'initialization' }
AllocationsGroupedByTablePresenter >> initializePresenters [

	tablePresenter := self newTable
		activateOnSingleClick;
		items: groupedAllocations;
		alternateRowsColor;
		yourself.
	
	tablePresenter
		addColumn: (SpStringTableColumn
			title: self titleForGroupingColumn
			evaluated: [ :assoc | assoc key ]).
	tablePresenter
		addColumn: (SpStringTableColumn
			title: 'Total allocated objects'
			evaluated: [ :assoc | assoc value size asStringWithCommas ]);
		addColumn: (SpStringTableColumn
			title: '% Allocations'
			evaluated: [ :assoc | self convertToPercentageString: (assoc value size / totalAllocations) ]).
	tablePresenter
		addColumn: (SpStringTableColumn
			title: 'Total allocated memory'
			evaluated: [ :assoc | (assoc value sum: [ :e | e sizeInBytes ]) humanReadableByteSizeString ]);
		addColumn: (SpStringTableColumn
			title: '% Memory'
			evaluated: [ :assoc | self convertToPercentageString: (assoc value sum: [ :e | e sizeInBytes ]) / totalMemory ])
]

{ #category : 'accessing - model' }
AllocationsGroupedByTablePresenter >> setModelBeforeInitialization: someObjectAllocations [

	groupedAllocations := self groupAllocations: someObjectAllocations.
	groupedAllocations sort: [ :a :b | a key < b key ].
	totalMemory := groupedAllocations sum: [ :assoc | assoc value sum: [ :e | e sizeInBytes ] ].
	totalAllocations := groupedAllocations sum: [ :assoc | assoc value size ].
]

{ #category : 'initialization' }
AllocationsGroupedByTablePresenter >> titleForGroupingColumn [

	^ self subclassResponsibility
]
