Class {
	#name : 'FinalizationLifetimesTablePresenter',
	#superclass : 'AllocationsGroupedByTablePresenter',
	#category : 'IllimaniUI-Widgets',
	#package : 'IllimaniUI',
	#tag : 'Widgets'
}

{ #category : 'accessing - model' }
FinalizationLifetimesTablePresenter >> groupAllocations: someObjectAllocations [

	^ (someObjectAllocations groupedBy: [ :allocationModel |
		 allocationModel lifetimeAsDuration asSeconds ]) associations
]

{ #category : 'initialization' }
FinalizationLifetimesTablePresenter >> titleForGroupingColumn [

	^ 'Lifetime duration (seconds)'
]
