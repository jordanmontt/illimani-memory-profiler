Class {
	#name : #SebasSebasPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'tablePresenter',
		'model',
		'textInput'
	],
	#category : #'AllocationProfiler-UI-Widgets'
}

{ #category : #initialization }
SebasSebasPresenter >> connectPresenters [

	textInput whenTextChangedDo: [ :aText | self filterTable: aText ]
]

{ #category : #layout }
SebasSebasPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  spacing: 5;
		  add: tablePresenter;
		  add: textInput expand: false;
		  yourself
]

{ #category : #'accessing - model' }
SebasSebasPresenter >> filterTable: aText [

	| newItems |
	aText ifEmpty: [
		tablePresenter items: self tableItems.
		^ self ].
	newItems := self tableItems select: [ :item |
		            item allocator asString includesSubstring: aText caseSensitive: false ].
	tablePresenter items: newItems
]

{ #category : #initialization }
SebasSebasPresenter >> initializePresenters [

	textInput := self newTextInput
		             placeholder: 'Filter';
		             yourself.
	tablePresenter := self newTable.
	tablePresenter
		addColumn: (SpIndexTableColumn new
				 title: 'Index';
				 " sortFunction: #yourself ascending;"width: 60;
				 yourself);
		addColumn: (SpStringTableColumn new
				 title: 'Allocator';
				 evaluated: [ :each | StObjectPrinter asTruncatedTextFrom: each allocator ];
				 sortFunction: #printString ascending;
				 yourself);
		addColumn: (SpStringTableColumn new
				 title: 'Total allocations';
				 evaluated: [ :each | each totalAllocations asString ];
				 sortFunction: #totalAllocations ascending;
				 yourself);
		addColumn: (SpStringTableColumn new
				 title: 'Total size in memory in bytes';
				 evaluated: [ :each | each totalSizeInBytes asString ];
				 sortFunction: #totalSizeInBytes ascending;
				 yourself);
		items: self tableItems
]

{ #category : #'accessing - model' }
SebasSebasPresenter >> setModelBeforeInitialization: aProfiler [

	model := aProfiler
]

{ #category : #'accessing - model' }
SebasSebasPresenter >> tableItems [

	^ model stats allocationsByClass
]
