Class {
	#name : 'IllAllocationRateProfilerUI',
	#superclass : 'IllAbstractUI',
	#category : 'Illimani-FrameworkProfiler-Examples-Allocation-Rate-Profiler',
	#package : 'Illimani-FrameworkProfiler-Examples',
	#tag : 'Allocation-Rate-Profiler'
}

{ #category : 'accessing' }
IllAllocationRateProfilerUI >> codeEvaluatorText [

	^ 'self'
]

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
