Extension { #name : 'IllGroupedAllocations' }

{ #category : '*FiLiP-MemoryProfiler-UI' }
IllGroupedAllocations >> inspectorExtension: aBuilder [

	<inspectorPresentationOrder: 0 title: 'Title'>
	^ SpListPresenter new
		  items: self asOrderedCollection;
		  yourself
]
