Class {
	#name : 'RelativeLifetimesByFullGCsTablePresenter',
	#superclass : 'AllocationsGroupedByTablePresenter',
	#category : 'FiLiP-MemoryProfiler-UI',
	#package : 'FiLiP-MemoryProfiler-UI'
}

{ #category : 'accessing - model' }
RelativeLifetimesByFullGCsTablePresenter >> groupAllocations: someObjectAllocations [

	^ (someObjectAllocations groupedBy: [ :allocationModel |
		   allocationModel survivedFullGC ]) associations
]

{ #category : 'initialization' }
RelativeLifetimesByFullGCsTablePresenter >> titleForGroupingColumn [

	^ '# of full GCs survived'
]
