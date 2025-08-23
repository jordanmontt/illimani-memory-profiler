Class {
	#name : 'SummaryFiLiPPresenter',
	#superclass : 'IllProfilingSummaryPresenter',
	#category : 'FiLiP-MemoryProfiler-UI-Widgets',
	#package : 'FiLiP-MemoryProfiler-UI',
	#tag : 'Widgets'
}

{ #category : 'layout' }
SummaryFiLiPPresenter >> generalStatsAssociations [

	^ super generalStatsAssociations , {
		  ('Total allocated objects'
		   -> profiler queryAllocationStats totalAllocations asStringWithCommas).
		  ('Sum of memory sizes from sampled data'
		   -> profiler queryAllocationStats totalAllocatedMemory humanReadableByteSizeString).
		  ('Total allocator methods'
		   -> profiler queryAllocationStats numberOfAllocationSites asString) }
]
