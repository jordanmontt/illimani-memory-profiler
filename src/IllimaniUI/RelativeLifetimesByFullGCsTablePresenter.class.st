Class {
	#name : 'RelativeLifetimesByFullGCsTablePresenter',
	#superclass : 'AllocationsGroupedByTablePresenter',
	#category : 'IllimaniUI-Widgets',
	#package : 'IllimaniUI',
	#tag : 'Widgets'
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
