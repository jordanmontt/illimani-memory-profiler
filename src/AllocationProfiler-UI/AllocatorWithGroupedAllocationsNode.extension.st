Extension { #name : #AllocatorWithGroupedAllocationsNode }

{ #category : #'*AllocationProfiler-UI' }
AllocatorWithGroupedAllocationsNode >> inspectorExtension: aBuilder [

	<inspectorPresentationOrder: 0 title: 'Items'>
	^ aBuilder newPresenter
		  layout: (SpBoxLayout newTopToBottom
				   spacing: 5;
				   add: (SpBoxLayout newLeftToRight
						    add: 'Allocator: ';
						    add: self allocator asString;
						    yourself)
				   expand: false;
				   add: (SpBoxLayout newLeftToRight
						    add: 'Total allocations: ';
						    add: self totalAllocations asString;
						    yourself)
				   expand: false;
				   add: (SpBoxLayout newLeftToRight
						    add: 'Total size in memory: ';
						    add: self totalSizeInBytes asString;
						    yourself)
				   expand: false;
				   add: (groupedAllocations inspectionItems: aBuilder);
				   yourself);
		  yourself
]
