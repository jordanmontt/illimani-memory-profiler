Extension { #name : #AllocationInfoDTO }

{ #category : #'*AllocationProfiler-UI' }
AllocationInfoDTO >> inspectorExtension: aBuilder [
	<inspectorPresentationOrder: 0 title: 'Items'>

	| tablePresenter elements |
	elements := { 'Allocated Object Class' -> allocatedObjectClass . 'Allocator Class' -> allocatorClass . 'Allocator Method Name' -> allocatorMethodName . 'Total Size in Bytes' -> totalSizeInBytes . 'Timestamp' -> timestamp . 'Context' -> context . 'Allocated Object' -> allocatedObject . 'Allocated Object Hash' -> allocatedObjectHash }.
	tablePresenter := aBuilder newTable.
	tablePresenter
		addColumn: (SpStringTableColumn title: 'Name' evaluated: #key);
		addColumn: (SpStringTableColumn title: 'Value' evaluated: #value);
		items: (elements collect: [ :e | StInspectorAssociationNode hostObject: e ]);
		beResizable.
	^ tablePresenter
]
