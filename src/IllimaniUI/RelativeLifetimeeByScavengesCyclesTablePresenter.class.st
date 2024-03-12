Class {
	#name : 'RelativeLifetimeeByScavengesCyclesTablePresenter',
	#superclass : 'AllocationsGroupedByTablePresenter',
	#category : 'IllimaniUI-Widgets',
	#package : 'IllimaniUI',
	#tag : 'Widgets'
}

{ #category : 'accessing - model' }
RelativeLifetimeeByScavengesCyclesTablePresenter >> groupAllocations: someObjectAllocations [

	^ (someObjectAllocations groupedBy: [ :allocationModel |
		   allocationModel survivedScavenges ]) associations
]

{ #category : 'initialization' }
RelativeLifetimeeByScavengesCyclesTablePresenter >> titleForGroupingColumn [

	^ '# of scavenges survived'
]
