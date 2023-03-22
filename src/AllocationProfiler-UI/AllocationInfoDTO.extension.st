Extension { #name : #AllocationInfoDTO }

{ #category : #'*AllocationProfiler-UI' }
AllocationInfoDTO >> inspectorExtension: aBuilder [
	<inspectorPresentationOrder: 0 title: 'Items'>

	| tablePresenter elements items |
	elements := { 'Allocated Object Class' -> allocatedObjectClass . 'Allocator Class' -> allocatorClass . 'Allocator Method' -> allocatorMethod . 'Total Size in Bytes' -> totalSizeInBytes . 'Timestamp' -> timestamp . 'Context' -> context . 'Allocated Object Hash' -> allocatedObjectHash }.
	items :=  (elements collect: [ :e | StInspectorAssociationNode hostObject: e ]).
	tablePresenter := aBuilder newTable.
	tablePresenter
		addColumn: (SpStringTableColumn title: 'Name' evaluated: #key);
		addColumn: (SpStringTableColumn title: 'Value' evaluated: #value);
		items: items;
		beResizable.
	^ tablePresenter
]
