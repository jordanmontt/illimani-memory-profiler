Class {
	#name : 'RelativeLifetimesByScavengesTablePresenter',
	#superclass : 'AllocationsGroupedByTablePresenter',
	#category : 'IllimaniUI-Widgets',
	#package : 'IllimaniUI',
	#tag : 'Widgets'
}

{ #category : 'accessing - model' }
RelativeLifetimesByScavengesTablePresenter >> groupAllocations: someObjectAllocations [

	^ (someObjectAllocations groupedBy: [ :allocationModel |
		   allocationModel survivedScavenges ]) associations
]

{ #category : 'initialization' }
RelativeLifetimesByScavengesTablePresenter >> titleForGroupingColumn [

	^ '# of scavenges survived'
]
