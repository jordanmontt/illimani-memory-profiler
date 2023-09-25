Class {
	#name : 'FinalizationScavengesCyclesTablePresenter',
	#superclass : 'AllocationsGroupedByTablePresenter',
	#category : 'IllimaniUI-Widgets',
	#package : 'IllimaniUI',
	#tag : 'Widgets'
}

{ #category : 'accessing - model' }
FinalizationScavengesCyclesTablePresenter >> groupAllocations: someObjectAllocations [

	^ (someObjectAllocations groupedBy: [ :allocationModel |
		   allocationModel survivedScavenges ]) associations
]

{ #category : 'initialization' }
FinalizationScavengesCyclesTablePresenter >> titleForGroupingColumn [

	^ '# of scavenges survived'
]
