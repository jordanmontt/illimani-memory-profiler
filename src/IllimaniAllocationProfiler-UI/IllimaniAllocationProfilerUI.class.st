"
I am a user interface for my profiling. My implementation is independent from the one of my profiler.
"
Class {
	#name : 'IllimaniAllocationProfilerUI',
	#superclass : 'IllimaniAbstractUI',
	#instVars : [
		'heatmapPresenter',
		'allocationsPerSecondPerAllocatorPresenter',
		'allocatedObjectsPerSecondPresenter',
		'memoryTablePresenter'
	],
	#category : 'IllimaniAllocationProfiler-UI-Main Presenter',
	#package : 'IllimaniAllocationProfiler-UI',
	#tag : 'Main Presenter'
}

{ #category : 'accessing - lazy roassal presenters' }
IllimaniAllocationProfilerUI >> allocatedObjectsPerSecondPerClassPresenter [

	^ SpRoassalPresenter new
		canvas: (IllimaniRoassalChartBuilder new
			model: profiler;
			topCalculationsNumber: topCalculationsNumber;
			allocatedObjectsPerSecondPerClassLineChartCanvas);
		yourself
]

{ #category : 'accessing - lazy roassal presenters' }
IllimaniAllocationProfilerUI >> allocatedObjectsPerSecondPerMethodPresenter [

	^ SpRoassalPresenter new
		canvas: (IllimaniRoassalChartBuilder new
			model: profiler;
			topCalculationsNumber: topCalculationsNumber;
			allocatedObjectsPerSecondPerMethodLineChartCanvas);
		yourself
]

{ #category : 'accessing - lazy roassal presenters' }
IllimaniAllocationProfilerUI >> allocatedObjectsPerSecondPresenter [

	allocatedObjectsPerSecondPresenter ifNil: [ self initializeAllocatedObjectsPerSecond ].
	^ allocatedObjectsPerSecondPresenter
]

{ #category : 'accessing - lazy roassal presenters' }
IllimaniAllocationProfilerUI >> allocationsPerSecondPerAllocatorPresenter [

	allocationsPerSecondPerAllocatorPresenter ifNil: [ self initializeAllocationsPerSecondPerAllocator ].
	^ allocationsPerSecondPerAllocatorPresenter
]

{ #category : 'accessing' }
IllimaniAllocationProfilerUI >> codeEvaluatorText [

	^ 'self objectAllocations.
self stats allocationsByClass.
self stats allocationsByMethod'
]

{ #category : 'accessing - lazy roassal presenters' }
IllimaniAllocationProfilerUI >> heatMapPresenter [

	heatmapPresenter ifNil: [ self initializeHeatmapPresenter ].
	^ heatmapPresenter
]

{ #category : 'initialization - lazy roassal presenters' }
IllimaniAllocationProfilerUI >> initializeAllocatedObjectsPerSecond [

	allocatedObjectsPerSecondPresenter := SpRoassalPresenter new
		canvas: (IllimaniRoassalChartBuilder new
			model: profiler;
			topCalculationsNumber: topCalculationsNumber;
			allocatedObjectsPerSecondLineChartCanvas);
		yourself
]

{ #category : 'initialization - lazy roassal presenters' }
IllimaniAllocationProfilerUI >> initializeAllocationsPerSecondPerAllocator [

	allocationsPerSecondPerAllocatorPresenter := AlternatorPresenter new
		  presenterOne: self allocatedObjectsPerSecondPerClassPresenter withName: 'Classes';
		  presenterTwo: self allocatedObjectsPerSecondPerMethodPresenter withName: 'Methods';
		  yourself
]

{ #category : 'initialization - lazy roassal presenters' }
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
IllimaniAllocationProfilerUI >> initializeMemoryTablePresenter [

	memoryTablePresenter := AlternatorPresenter new
		presenterOne: (TableMemoryInformationPresenter owner: self on: profiler stats allocationsByClass)
		withName: 'Classes';
		presenterTwo: (TableMemoryInformationPresenter owner: self on: profiler stats allocationsByMethod)
		withName: 'Methods';
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

{ #category : 'actions' }
IllimaniAllocationProfilerUI >> refresh [

	self layout: self defaultLayout.
	heatmapPresenter := nil.
	allocationsPerSecondPerAllocatorPresenter := nil.
	allocatedObjectsPerSecondPresenter := nil
]

{ #category : 'initialization - lazy presenters' }
IllimaniAllocationProfilerUI >> summaryStatsPresenter [

	^ AllocationSiteSummaryPresenter on: profiler
]

{ #category : 'initialization' }
IllimaniAllocationProfilerUI >> title [

	^ 'Illimani Allocation Sites Memory Profiler'
]
