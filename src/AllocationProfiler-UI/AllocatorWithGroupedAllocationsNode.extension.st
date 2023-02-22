Extension { #name : #AllocatorWithGroupedAllocationsNode }

{ #category : #'*AllocationProfiler-UI' }
AllocatorWithGroupedAllocationsNode >> inspectorExtension: aBuilder [

	<inspectorPresentationOrder: 0 title: 'Summary'>
	| elements tablePresenter |
	elements := { 'Allocator' -> allocator . 'Total allocations' -> self totalAllocations . 'Total size in memory' -> self totalSizeInBytes }.
	tablePresenter := aBuilder newTable.
	tablePresenter
		addColumn: (SpStringTableColumn title: 'Name' evaluated: #key);
		addColumn: (SpStringTableColumn title: 'Value' evaluated: #value);
		items: (elements collect: [ :e | StInspectorAssociationNode hostObject: e ]);
		beResizable.
	^ tablePresenter
]

{ #category : #'*AllocationProfiler-UI' }
AllocatorWithGroupedAllocationsNode >> inspectorExtensionGroupedAllocations: aBuilder [

	<inspectorPresentationOrder: 1 title: 'Grouped Allocations'>
	| tablePresenter |
	tablePresenter := aBuilder newTable.
	tablePresenter
		addColumn: (SpStringTableColumn
			title: 'Key'
			evaluated: [ :each | StObjectPrinter asTruncatedTextFrom: each key ]) beSortable;
		addColumn: (SpStringTableColumn
			title: 'Value'
			evaluated: [ :each | each value size asString , ' instances' ]) beSortable;
		items: (groupedAllocations associations collect: [ :e |
			StInspectorAssociationNode hostObject: e ]).
	^ tablePresenter
]
