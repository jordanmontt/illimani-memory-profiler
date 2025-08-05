Class {
	#name : 'IllAllocationRateProfilerUI',
	#superclass : 'IllSimpleUI',
	#category : 'Illimani-FrameworkProfiler-Examples-Allocation-Rate-Profiler',
	#package : 'Illimani-FrameworkProfiler-Examples',
	#tag : 'Allocation-Rate-Profiler'
}

{ #category : 'initialization - lazy presenters' }
IllAllocationRateProfilerUI >> profilerSummaryPresenter [

	^ IllSummaryAllocationRatePresenter on: profiler
]

{ #category : 'actions' }
IllAllocationRateProfilerUI >> refresh [
	"Don't do nothing as there is nothing to refresh"

	^ self
]

{ #category : 'initialization' }
IllAllocationRateProfilerUI >> title [

	^ 'Allocation Rate Memory Profiler'
]
