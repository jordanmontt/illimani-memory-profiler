Class {
	#name : 'RelativeLifetimesByMBTablePresenter',
	#superclass : 'AllocationsGroupedByTablePresenter',
	#category : 'IllimaniUI-Widgets',
	#package : 'IllimaniUI',
	#tag : 'Widgets'
}

{ #category : 'accessing - model' }
RelativeLifetimesByMBTablePresenter >> groupAllocations: someObjectAllocations [

	^ (someObjectAllocations groupedBy: [ :allocationModel |
		 allocationModel lifetime // (1024*1024*10) "10 megabytes" ]) associations
]

{ #category : 'initialization' }
RelativeLifetimesByMBTablePresenter >> titleForGroupingColumn [

	^ 'Lifetime duration (10 MB)'
]
