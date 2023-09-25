Class {
	#name : 'FinalizationFullGCCyclesTablePresenter',
	#superclass : 'AllocationsGroupedByTablePresenter',
	#category : 'IllimaniUI-Widgets',
	#package : 'IllimaniUI',
	#tag : 'Widgets'
}

{ #category : 'accessing - model' }
FinalizationFullGCCyclesTablePresenter >> groupAllocations: someObjectAllocations [

	^ (someObjectAllocations groupedBy: [ :allocationModel |
		   allocationModel survivedFullGC ]) associations
]

{ #category : 'initialization' }
FinalizationFullGCCyclesTablePresenter >> titleForGroupingColumn [

	^ '# of full GCs survived'
]
