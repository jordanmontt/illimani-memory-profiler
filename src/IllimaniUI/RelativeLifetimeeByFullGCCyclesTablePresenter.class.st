Class {
	#name : 'RelativeLifetimeeByFullGCCyclesTablePresenter',
	#superclass : 'AllocationsGroupedByTablePresenter',
	#category : 'IllimaniUI-Widgets',
	#package : 'IllimaniUI',
	#tag : 'Widgets'
}

{ #category : 'accessing - model' }
RelativeLifetimeeByFullGCCyclesTablePresenter >> groupAllocations: someObjectAllocations [

	^ (someObjectAllocations groupedBy: [ :allocationModel |
		   allocationModel survivedFullGC ]) associations
]

{ #category : 'initialization' }
RelativeLifetimeeByFullGCCyclesTablePresenter >> titleForGroupingColumn [

	^ '# of full GCs survived'
]
