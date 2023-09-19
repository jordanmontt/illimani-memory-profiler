"
I am a user interface for my profiling. My implementation is independent from the one of my profiler.
"
Class {
	#name : 'IllimaniAllocationProfilerUI',
	#superclass : 'IllimaniAbstractUI',
	#instVars : [
		'allocatedObjectsPerSecondPresenter',
		'codeEvaluator',
		'heatmapPresenter',
		'summaryAndEvaluatorPresenter',
		'memoryTablePresenter',
		'allocationsPerSecondPerAllocatorPresenter',
		'allocatedObjectsTablePresenter'
	],
	#category : 'IllimaniAllocationProfiler-UI-Main Presenter',
	#package : 'IllimaniAllocationProfiler-UI',
	#tag : 'Main Presenter'
}

{ #category : 'accessing - lazy presenters' }
IllimaniAllocationProfilerUI >> allocatedObjectsPerSecondPerClassPresenter [

	^ SpRoassalPresenter new
		canvas: (IllimaniRoassalChartBuilder new
			model: profiler;
			topCalculationsNumber: topCalculationsNumber;
			allocatedObjectsPerSecondPerClassLineChartCanvas);
		yourself
]

{ #category : 'accessing - lazy presenters' }
IllimaniAllocationProfilerUI >> allocatedObjectsPerSecondPerMethodPresenter [

	^ SpRoassalPresenter new
		canvas: (IllimaniRoassalChartBuilder new
			model: profiler;
			topCalculationsNumber: topCalculationsNumber;
			allocatedObjectsPerSecondPerMethodLineChartCanvas);
		yourself
]

{ #category : 'accessing - lazy presenters' }
IllimaniAllocationProfilerUI >> allocatedObjectsPerSecondPresenter [

	allocatedObjectsPerSecondPresenter ifNil: [ self initializeAllocatedObjectsPerSecond ].
	^ allocatedObjectsPerSecondPresenter
]

{ #category : 'accessing - lazy presenters' }
IllimaniAllocationProfilerUI >> allocatedObjectsTablePresenter [

	allocatedObjectsTablePresenter ifNil: [ self initializeAllocatedObjectsTablePresenter ].
	^ allocatedObjectsTablePresenter
]

{ #category : 'accessing - lazy presenters' }
IllimaniAllocationProfilerUI >> allocationsPerSecondPerAllocatorPresenter [

	allocationsPerSecondPerAllocatorPresenter ifNil: [ self initializeAllocationsPerSecondPerAllocator ].
	^ allocationsPerSecondPerAllocatorPresenter
]

{ #category : 'accessing - lazy presenters' }
IllimaniAllocationProfilerUI >> codeEvaluator [

	codeEvaluator ifNil: [ self initializeCodeEvaluator ].
	^ codeEvaluator
]

{ #category : 'accessing - lazy presenters' }
IllimaniAllocationProfilerUI >> heatMapPresenter [

	heatmapPresenter ifNil: [ self initializeHeatmapPresenter ].
	^ heatmapPresenter
]

{ #category : 'initialization - lazy presenters' }
IllimaniAllocationProfilerUI >> initializeAllocatedObjectsPerSecond [

	allocatedObjectsPerSecondPresenter := SpRoassalPresenter new
		canvas: (IllimaniRoassalChartBuilder new
			model: profiler;
			topCalculationsNumber: topCalculationsNumber;
			allocatedObjectsPerSecondLineChartCanvas);
		yourself
]

{ #category : 'initialization - lazy presenters' }
IllimaniAllocationProfilerUI >> initializeAllocatedObjectsTablePresenter [

	allocatedObjectsTablePresenter := self instantiate: (AllocatedObjectsTablePresenter on: profiler objectAllocations)
]

{ #category : 'initialization - lazy presenters' }
IllimaniAllocationProfilerUI >> initializeAllocationsPerSecondPerAllocator [

	allocationsPerSecondPerAllocatorPresenter := AlternatorPresenter new
		  presenterOne: self allocatedObjectsPerSecondPerClassPresenter withName: 'Classes';
		  presenterTwo: self allocatedObjectsPerSecondPerMethodPresenter withName: 'Methods';
		  yourself
]

{ #category : 'initialization - lazy presenters' }
IllimaniAllocationProfilerUI >> initializeHeatmapPresenter [

	| roassalPresenterByClass roassalPresenterByMethod |
	roassalPresenterByClass := self instantiate: SpRoassalPresenter.
	roassalPresenterByClass canvas: (IllimaniRoassalChartBuilder new
			 model: profiler;
			 topCalculationsNumber: topCalculationsNumber;
			 heatmapAllocatorAllocatedCanvasByClass).
	roassalPresenterByMethod := self instantiate: SpRoassalPresenter.
	roassalPresenterByMethod canvas: (IllimaniRoassalChartBuilder new
			 model: profiler;
			 topCalculationsNumber: topCalculationsNumber;
			 heatmapAllocatorAllocatedCanvasByMethod).

	heatmapPresenter :=( self instantiate: AlternatorPresenter)
		presenterOne: roassalPresenterByClass withName: 'Classes';
		presenterTwo: roassalPresenterByMethod  withName: 'Methods';
		yourself
]

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

{ #category : 'accessing - lazy presenters' }
IllimaniAllocationProfilerUI >> memoryTablePresenter [

	memoryTablePresenter ifNil: [ self initializeMemoryTablePresenter ].
	^ memoryTablePresenter
]

{ #category : 'accessing - lazy presenters' }
IllimaniAllocationProfilerUI >> notebookPresenter [

	notebookPresenter ifNil: [ self initializeNotebook ].
	^ notebookPresenter
]

{ #category : 'actions' }
IllimaniAllocationProfilerUI >> refresh [

	self layout: self defaultLayout.
	heatmapPresenter := nil.
	allocationsPerSecondPerAllocatorPresenter := nil.
	allocatedObjectsPerSecondPresenter := nil
]

{ #category : 'accessing - lazy presenters' }
IllimaniAllocationProfilerUI >> summaryAndEvaluatorPresenter [

	summaryAndEvaluatorPresenter ifNil: [ self initializeSummaryAndEvaluatorPresenter ].
	^ summaryAndEvaluatorPresenter
]
