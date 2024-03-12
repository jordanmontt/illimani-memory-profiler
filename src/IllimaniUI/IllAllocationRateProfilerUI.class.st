Class {
	#name : 'IllAllocationRateProfilerUI',
	#superclass : 'IllAbstractUI',
	#category : 'IllimaniUI-Main Presenter',
	#package : 'IllimaniUI',
	#tag : 'Main Presenter'
}

{ #category : 'accessing' }
IllAllocationRateProfilerUI >> codeEvaluatorText [
    ^ 'self'
]

{ #category : 'initialization' }
IllAllocationRateProfilerUI >> initializeNotebook [

	notebookPresenter := self newNotebook
		addPageTitle: 'Summary' provider: [ self summaryAndEvaluatorPresenter ];
		addPageTitle: 'Evaluator' provider: [ self codeEvaluator ];
		yourself
]

{ #category : 'initialization - lazy presenters' }
IllAllocationRateProfilerUI >> profilerSummaryPresenter [

	^ ProfilerSummaryPresenter on: profiler
]

{ #category : 'actions' }
IllAllocationRateProfilerUI >> refresh [
	"Don't do nothing as there is nothing to refresh"

	^ self
]

{ #category : 'initialization' }
IllAllocationRateProfilerUI >> title [

	^ 'Illimani Allocation Rate Memory Profiler'
]
