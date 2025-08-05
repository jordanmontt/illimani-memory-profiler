Class {
	#name : 'IllSummaryAllocationRatePresenter',
	#superclass : 'IllProfilingSummaryPresenter',
	#category : 'Illimani-FrameworkProfiler-Examples-Allocation-Rate-Profiler',
	#package : 'Illimani-FrameworkProfiler-Examples',
	#tag : 'Allocation-Rate-Profiler'
}

{ #category : 'layout' }
IllSummaryAllocationRatePresenter >> generalStatsAssociations [

	^ super generalStatsAssociations , {
		  ('Total allocated objects'
		   -> profiler totalAllocations asStringWithCommas).
		  ('Sum of memory sizes from sampled data'
		   -> profiler totalAllocatedMemory humanReadableByteSizeString) }
]
