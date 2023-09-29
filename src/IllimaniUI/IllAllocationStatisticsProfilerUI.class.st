Class {
	#name : 'IllAllocationStatisticsProfilerUI',
	#superclass : 'IllAbstractUI',
	#category : 'IllimaniUI-Main Presenter',
	#package : 'IllimaniUI',
	#tag : 'Main Presenter'
}

{ #category : 'accessing' }
IllAllocationStatisticsProfilerUI >> codeEvaluatorText [

	^ 'self objectAllocations'
]

{ #category : 'initialization' }
IllAllocationStatisticsProfilerUI >> initializeNotebook [

	notebookPresenter := self newNotebook
		addPageTitle: 'Summary' provider: [ self summaryAndEvaluatorPresenter ];
		addPageTitle: 'Allocated Objects' provider: [ self allocatedObjectsTablePresenter ];

		addPageTitle: 'Evaluator' provider: [ self codeEvaluator ];
		yourself
]

{ #category : 'initialization - lazy presenters' }
IllAllocationStatisticsProfilerUI >> summaryStatsPresenter [

	^ AllocationSummaryPresenter on: profiler
]
