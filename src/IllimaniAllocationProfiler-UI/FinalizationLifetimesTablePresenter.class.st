Class {
	#name : 'FinalizationLifetimesTablePresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'tablePresenter',
		'groupedAllocationsBySeconds',
		'totalMemory',
		'totalAllocations'
	],
	#category : 'IllimaniAllocationProfiler-UI-Widgets',
	#package : 'IllimaniAllocationProfiler-UI',
	#tag : 'Widgets'
}

{ #category : 'initialization' }
FinalizationLifetimesTablePresenter >> convertToPercentageString: aNumber [

	^ (aNumber * 100 printShowingDecimalPlaces: 2) , '%'
]

{ #category : 'layout' }
FinalizationLifetimesTablePresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		add: tablePresenter;
		yourself
]

{ #category : 'initialization' }
FinalizationLifetimesTablePresenter >> initializePresenters [

	tablePresenter := self newTable
		items: groupedAllocationsBySeconds;
		alternateRowsColor;
		addColumn: (SpStringTableColumn
			title: 'Lifetime duration (seconds)'
			evaluated: [ :assoc | assoc key ]);
		addColumn: (SpStringTableColumn
			title: 'Total allocated memory'
			evaluated: [ :assoc | (assoc value sum: [ :e | e totalSizeInBytes ]) humanReadableByteSizeString ]);
		addColumn: (SpStringTableColumn
			title: '% Memory'
			evaluated: [ :assoc | self convertToPercentageString: (assoc value sum: [ :e | e totalSizeInBytes ]) / totalMemory ]);
		addColumn: (SpStringTableColumn
			title: '# of allocated objects'
			evaluated: [ :assoc | assoc value size asStringWithCommas ]);
		addColumn: (SpStringTableColumn
			title: '% Allocated objects'
			evaluated: [ :assoc | self convertToPercentageString: (assoc value size / totalAllocations) ]);
			yourself
]

{ #category : 'accessing - model' }
FinalizationLifetimesTablePresenter >> setModelBeforeInitialization: someObjectAllocations [

	groupedAllocationsBySeconds := (someObjectAllocations groupedBy: [ :allocationModel |
		allocationModel lifetimeAsDuration asSeconds ]) associations.
	groupedAllocationsBySeconds sort: [ :a :b | a key < b key ].
	totalMemory := groupedAllocationsBySeconds sum: [ :assoc | assoc value sum: [ :e | e totalSizeInBytes ] ].
	totalAllocations := groupedAllocationsBySeconds sum: [ :assoc | assoc value size ].
]
