"
I am a user interface for my profiling. My implementation is independent from the one of my profiler.
"
Class {
	#name : 'IllimaniAllocationProfilerUI',
	#superclass : 'IllimaniAbstractUI',
	#traits : 'IllimaniTInformationPresenters + IllimaniTRoassalPresenters',
	#classTraits : 'IllimaniTInformationPresenters classTrait + IllimaniTRoassalPresenters classTrait',
	#category : 'IllimaniAllocationProfiler-UI-Main Presenter',
	#package : 'IllimaniAllocationProfiler-UI',
	#tag : 'Main Presenter'
}

{ #category : 'initialization - lazy presenters' }
IllimaniAllocationProfilerUI >> initializeNotebook [

	notebookPresenter := self newNotebook
		addPageTitle: 'Summary' provider: [ self summaryAndEvaluatorPresenter ];
		addPageTitle: 'Memory' provider: [ self memoryTablePresenter  ];
		addPageTitle: 'Allocated Objects' provider: [ self allocatedObjectsTablePresenter ];
		addPageTitle: 'Heatmap' provider: [ self heatMapPresenter ];
		addPageTitle: 'Allocations per Second Total'
		provider: [ self allocatedObjectsPerSecondPresenter ];
		addPageTitle: 'Allocations per Second per Allocator'
		provider: [ self allocationsPerSecondPerAllocatorPresenter ];

		addPageTitle: 'Evaluator' provider: [ self codeEvaluator ];
		yourself
]

{ #category : 'actions' }
IllimaniAllocationProfilerUI >> refresh [

	self layout: self defaultLayout.
	heatmapPresenter := nil.
	allocationsPerSecondPerAllocatorPresenter := nil.
	allocatedObjectsPerSecondPresenter := nil
]
