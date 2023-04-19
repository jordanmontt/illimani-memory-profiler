Extension { #name : #AllocationInfoDTO }

{ #category : #'*IllimaniAllocationProfiler-UI' }
AllocationInfoDTO >> inspectorExtension: aBuilder [
	<inspectorPresentationOrder: 0 title: 'Items'>

	| tablePresenter elements items |
	elements := { 'Allocated Object Class' -> allocatedObjectClass . 'Allocator Class' -> allocatorClass . 'Allocator Method' -> allocatorMethod . 'Total Size in Bytes' -> totalSizeInBytes . 'Allocation microsends timestamp' -> timestamp . 'Garbage collected timestamp' -> finalizationTimestamp . 'Lifetime of the obejct' -> self lifetimeAsString . 'Context' -> context . 'Allocated Object' -> allocatedObject . 'Allocated Object Identity Hash' -> allocatedObjectHash }.
	items :=  (elements collect: [ :e | StInspectorAssociationNode hostObject: e ]).
	tablePresenter := aBuilder newTable.
	tablePresenter
		addColumn: (SpStringTableColumn title: 'Name' evaluated: #key);
		addColumn: (SpStringTableColumn title: 'Value' evaluated: #value);
		items: items;
		beResizable.
	^ tablePresenter
]

{ #category : #'*IllimaniAllocationProfiler-UI' }
AllocationInfoDTO >> inspectorExtensionContextFingerprint: aBuilder [

	<inspectorPresentationOrder: 1 title: 'Allocation Context Fingerprint'>
	^ contextFingerprint inspectionFullString
]
