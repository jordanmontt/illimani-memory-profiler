"
I am a table that shows the information of number of allocations and size in memory 
"
Class {
	#name : 'AllocationsByAllocatorTablePresenter',
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
AllocationsByAllocatorTablePresenter >> connectPresenters [

	textInput whenTextChangedDo: [ :aText | self filterTable: aText ].
	tablePresenter whenSelectedDo: [ :item | item inspect ]
]

{ #category : 'layout' }
AllocationsByAllocatorTablePresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  spacing: 5;
		  add: tablePresenter;
		  add: textInput expand: false;
		  yourself
]

{ #category : 'accessing - model' }
AllocationsByAllocatorTablePresenter >> filterTable: aText [

	| newItems |
	aText ifEmpty: [
		tablePresenter items: self tableItems.
		^ self ].
	newItems := self tableItems select: [ :item |
		            item allocator asString includesSubstring: aText caseSensitive: false ].
	tablePresenter items: newItems
]

{ #category : 'initialization' }
AllocationsByAllocatorTablePresenter >> initializePresenters [

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
			evaluated: [ :each | StObjectPrinter asTruncatedTextFrom: each key method name ];
			sortFunction: #printString ascending;
			yourself);
		addColumn: (SpStringTableColumn new
			title: 'Total allocations';
			evaluated: [ :each | each totalAllocations asStringWithCommas ];
			sortFunction: #totalAllocations ascending;
			width: 120;
			yourself);
		addColumn: (SpStringTableColumn new
			width: 60;
			title: '%';
			evaluated: [ :e |
				(((e totalAllocations / self totalAllocations) * 100) asFloat printShowingDecimalPlaces: 2) , '%' ];
			yourself);
		addColumn: (SpStringTableColumn new
			title: 'Total memory';
			evaluated: [ :each | each totalAllocatedMemory humanReadableByteSizeString ];
			sortFunction: #sizeInBytes ascending;
			width: 120;
			yourself);
		addColumn: (SpStringTableColumn new
			width: 60;
			title: '%';
			evaluated: [ :e |
				(((e totalAllocatedMemory / self sizeInBytes) * 100) asFloat printShowingDecimalPlaces: 2) , '%'];
			yourself);
		items: self tableItems
]

{ #category : 'accessing - model' }
AllocationsByAllocatorTablePresenter >> setModelBeforeInitialization: someTableItems [

	tableItems := someTableItems
]

{ #category : 'accessing' }
AllocationsByAllocatorTablePresenter >> sizeInBytes [

	^ totalSizeInBytes ifNil: [ totalSizeInBytes := tableItems sum: [ :e | e totalAllocatedMemory ] ]
]

{ #category : 'accessing - model' }
AllocationsByAllocatorTablePresenter >> tableItems [

	^ tableItems
]

{ #category : 'accessing' }
AllocationsByAllocatorTablePresenter >> totalAllocations [

	^ totalAllocations ifNil: [ totalAllocations := tableItems sum: [ :e | e totalAllocations ] ]
]
