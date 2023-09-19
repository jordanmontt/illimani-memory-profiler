Extension { #name : 'AllocatorWithGroupedAllocationsCollection' }

{ #category : '*IllimaniAllocationProfiler-UI' }
AllocatorWithGroupedAllocationsCollection >> inspectorExtension [

	<inspectorPresentationOrder: 0 title: 'Title'>
	^ SpListPresenter new
		  items: self asOrderedCollection;
		  yourself
]
