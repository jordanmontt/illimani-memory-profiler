Class {
	#name : #SebasSebasPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'listPresenter',
		'tablePresenter',
		'model'
	],
	#category : #'AllocationProfiler-UI-Widgets'
}

{ #category : #layout }
SebasSebasPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: tablePresenter;
		  yourself
]

{ #category : #initialization }
SebasSebasPresenter >> initializePresenters [

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
		items: model stats allocationsByClass
]

{ #category : #'accessing - model' }
SebasSebasPresenter >> setModelBeforeInitialization: aProfiler [

	model := aProfiler
]
