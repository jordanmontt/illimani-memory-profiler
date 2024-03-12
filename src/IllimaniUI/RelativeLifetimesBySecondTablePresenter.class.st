Class {
	#name : 'RelativeLifetimesBySecondTablePresenter',
	#superclass : 'AllocationsGroupedByTablePresenter',
	#category : 'IllimaniUI-Widgets',
	#package : 'IllimaniUI',
	#tag : 'Widgets'
}

{ #category : 'accessing - model' }
RelativeLifetimesBySecondTablePresenter >> groupAllocations: someObjectAllocations [

	^ (someObjectAllocations groupedBy: [ :allocationModel |
		 allocationModel lifetimeAsDuration asSeconds ]) associations
]

{ #category : 'initialization' }
RelativeLifetimesBySecondTablePresenter >> titleForGroupingColumn [

	^ 'Lifetime duration (seconds)'
]
