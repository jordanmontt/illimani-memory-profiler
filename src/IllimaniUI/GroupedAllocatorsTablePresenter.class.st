"
I am a table that shows the information of number of allocations and size in memory 
"
Class {
	#name : 'GroupedAllocatorsTablePresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'tablePresenter',
		'textInput',
		'tableItems',
		'totalAllocations',
		'totalSizeInBytes'
	],
	#category : 'IllimaniUI-Widgets',
	#package : 'IllimaniUI',
	#tag : 'Widgets'
}

{ #category : 'initialization' }
GroupedAllocatorsTablePresenter >> connectPresenters [

	textInput whenTextChangedDo: [ :aText | self filterTable: aText ].
	tablePresenter whenSelectedDo: [ :item | item inspect ]
]

{ #category : 'layout' }
GroupedAllocatorsTablePresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  spacing: 5;
		  add: tablePresenter;
		  add: textInput expand: false;
		  yourself
]

{ #category : 'accessing - model' }
GroupedAllocatorsTablePresenter >> filterTable: aText [

	| newItems |
	aText ifEmpty: [
		tablePresenter items: self tableItems.
		^ self ].
	newItems := self tableItems select: [ :item |
		            item allocator asString includesSubstring: aText caseSensitive: false ].
	tablePresenter items: newItems
]

{ #category : 'initialization' }
GroupedAllocatorsTablePresenter >> initializePresenters [

	textInput := self newTextInput
		placeholder: 'Filter';
		yourself.
	tablePresenter := self newTable.
	tablePresenter
		alternateRowsColor;
		activateOnSingleClick;
		addColumn: (SpIndexTableColumn new
			title: 'Index';
			width: 60;
			yourself);
		addColumn: (SpStringTableColumn new
			title: 'Allocator';
			evaluated: [ :each | StObjectPrinter asTruncatedTextFrom: each allocator ];
			sortFunction: #printString ascending;
			yourself);
		addColumn: (SpStringTableColumn new
			title: 'Total allocations';
			evaluated: [ :each | each totalAllocations asStringWithCommas ];
			sortFunction: #totalAllocations ascending;
			yourself);
		addColumn: (SpStringTableColumn new
			width: 60;
			title: '%';
			evaluated: [ :e |
				(((e totalAllocations / self totalAllocations) * 100) asFloat printShowingDecimalPlaces: 2) , '%' ];
			yourself);
		addColumn: (SpStringTableColumn new
			title: 'Total size in bytes';
			evaluated: [ :each | each sizeInBytes humanReadableByteSizeString ];
			sortFunction: #sizeInBytes ascending;
			yourself);
		addColumn: (SpStringTableColumn new
			width: 60;
			title: '%';
			evaluated: [ :e |
				(((e sizeInBytes / self sizeInBytes) * 100) asFloat printShowingDecimalPlaces: 2) , '%'];
			yourself);
		items: self tableItems
]

{ #category : 'accessing - model' }
GroupedAllocatorsTablePresenter >> setModelBeforeInitialization: someTableItems [

	tableItems := someTableItems
]

{ #category : 'accessing' }
GroupedAllocatorsTablePresenter >> sizeInBytes [

	^ totalSizeInBytes ifNil: [ totalSizeInBytes := tableItems sum: [ :e | e sizeInBytes ] ]
]

{ #category : 'accessing - model' }
GroupedAllocatorsTablePresenter >> tableItems [

	^ tableItems
]

{ #category : 'accessing' }
GroupedAllocatorsTablePresenter >> totalAllocations [

	^ totalAllocations ifNil: [ totalAllocations := tableItems sum: [ :e | e totalAllocations ] ]
]
