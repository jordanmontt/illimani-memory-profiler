Extension { #name : 'AllocatorWithGroupedAllocationsCollection' }

{ #category : '*IllimaniUI' }
AllocatorWithGroupedAllocationsCollection >> inspectorExtension [

	<inspectorPresentationOrder: 0 title: 'Title'>
	^ SpListPresenter new
		  items: self asOrderedCollection;
		  yourself
]
