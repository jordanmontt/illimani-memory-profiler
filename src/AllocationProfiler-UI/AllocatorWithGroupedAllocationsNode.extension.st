Extension { #name : #AllocatorWithGroupedAllocationsNode }

{ #category : #'*AllocationProfiler-UI' }
AllocatorWithGroupedAllocationsNode >> inspectorExtension: aBuilder [

	<inspectorPresentationOrder: 0 title: 'Items'>
	^ aBuilder newPresenter
		  layout: (SpBoxLayout newTopToBottom
				   spacing: 5;
				   add: 'Allocator:' expand: false;
				   add: self allocator asString expand: false;
				   add: (groupedAllocations inspectionItems: aBuilder);
				   yourself);
		  yourself
]
