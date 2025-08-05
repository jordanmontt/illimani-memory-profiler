Extension { #name : 'IllGroupedAllocationsByAllocatorNode' }

{ #category : '*FiLiP-MemoryProfiler-UI' }
IllGroupedAllocationsByAllocatorNode >> inspectorAllocSite: aBuilder [

	<inspectorPresentationOrder: 3 title: 'Allocation site'>
	^ key inspectorPresenter
]

{ #category : '*FiLiP-MemoryProfiler-UI' }
IllGroupedAllocationsByAllocatorNode >> inspectorExtension: aBuilder [

	<inspectorPresentationOrder: 0 title: 'Summary'>
	| elements tablePresenter |
	elements := { 'Allocator' -> "because of block closures" key . 'Total allocations' -> self totalAllocations . 'Total size in memory' -> self totalAllocatedMemory humanReadableByteSizeString }.
	tablePresenter := aBuilder newTable.
	tablePresenter
		addColumn: (SpStringTableColumn title: 'Name' evaluated: #key);
		addColumn: (SpStringTableColumn title: 'Value' evaluated: #value);
		items: (elements collect: [ :e | StInspectorAssociationNode hostObject: e ]);
		beResizable.
	^ tablePresenter
]

{ #category : '*FiLiP-MemoryProfiler-UI' }
IllGroupedAllocationsByAllocatorNode >> inspectorExtensionGroupedAllocations: aBuilder [

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
