Class {
	#name : 'RelativeLifetimesByScavengesTablePresenter',
	#superclass : 'AllocationsGroupedByTablePresenter',
	#category : 'FiLiP-MemoryProfiler-UI',
	#package : 'FiLiP-MemoryProfiler-UI'
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
