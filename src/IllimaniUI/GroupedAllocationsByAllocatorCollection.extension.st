Extension { #name : 'GroupedAllocationsByAllocatorCollection' }

{ #category : '*IllimaniUI' }
GroupedAllocationsByAllocatorCollection >> inspectorExtension [

	<inspectorPresentationOrder: 0 title: 'Title'>
	^ SpListPresenter new
		  items: self asOrderedCollection;
		  yourself
]
