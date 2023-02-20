Extension { #name : #AllocatorWithGroupedAllocationsCollection }

{ #category : #'*AllocationProfiler-UI' }
AllocatorWithGroupedAllocationsCollection >> inspectorExtension [

	<inspectorPresentationOrder: 0 title: 'Title'>
	^ SpListPresenter new
		  items: self asOrderedCollection;
		  yourself
]
