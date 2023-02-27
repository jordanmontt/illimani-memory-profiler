"
I am a table that shows the information of number of allocations and size in memory 
"
Class {
	#name : #TableMemoryInformationPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'tablePresenter',
		'textInput',
		'tableItems'
	],
	#category : #'AllocationProfiler-UI-Widgets'
}

{ #category : #initialization }
TableMemoryInformationPresenter >> connectPresenters [

	textInput
		whenTextChangedDo: [ :aText | self filterTable: aText ].
	tablePresenter
		whenSelectedDo: [ :item | item inspect ]
]

{ #category : #layout }
TableMemoryInformationPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  spacing: 5;
		  add: tablePresenter;
		  add: textInput expand: false;
		  yourself
]

{ #category : #'accessing - model' }
TableMemoryInformationPresenter >> filterTable: aText [

	| newItems |
	aText ifEmpty: [
		tablePresenter items: self tableItems.
		^ self ].
	newItems := self tableItems select: [ :item |
		            item allocator asString includesSubstring: aText caseSensitive: false ].
	tablePresenter items: newItems
]

{ #category : #initialization }
TableMemoryInformationPresenter >> initializePresenters [

	textInput := self newTextInput
		             placeholder: 'Filter';
		             yourself.
	tablePresenter := self newTable.
	tablePresenter
		alternateRowsColor;
		activateOnDoubleClick;
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
				 title: 'Total size in bytes';
				 evaluated: [ :each | each totalSizeInBytes humanReadableByteSizeString ];
				 sortFunction: #totalSizeInBytes ascending;
				 yourself);
		items: self tableItems
]

{ #category : #'accessing - model' }
TableMemoryInformationPresenter >> setModelBeforeInitialization: someTableItems [

	tableItems := someTableItems
]

{ #category : #'accessing - model' }
TableMemoryInformationPresenter >> tableItems [

	^ tableItems
]
