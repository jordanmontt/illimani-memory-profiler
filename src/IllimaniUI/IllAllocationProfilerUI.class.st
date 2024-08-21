"
I am a user interface for my profiling. My implementation is independent from the one of my profiler.
"
Class {
	#name : 'IllAllocationProfilerUI',
	#superclass : 'IllAbstractUI',
	#instVars : [
		'heatmapPresenter',
		'allocationsPerSecondPerAllocatorPresenter',
		'allocatedObjectsPerSecondPresenter',
		'memoryTablePresenter',
		'topCalculationsNumberInputPresenter',
		'topCalculationsNumber',
		'allocatedObjectsTablePresenter'
	],
	#category : 'IllimaniUI-Main Presenter',
	#package : 'IllimaniUI',
	#tag : 'Main Presenter'
}

{ #category : 'accessing - lazy roassal presenters' }
IllAllocationProfilerUI >> allocatedObjectsPerSecondPresenter [

	allocatedObjectsPerSecondPresenter ifNil: [ self initializeAllocatedObjectsPerSecond ].
	^ allocatedObjectsPerSecondPresenter
]

{ #category : 'accessing - lazy presenters' }
IllAllocationProfilerUI >> allocatedObjectsTablePresenter [

	allocatedObjectsTablePresenter ifNil: [ self initializeAllocatedObjectsTablePresenter ].
	^ allocatedObjectsTablePresenter
]

{ #category : 'accessing - lazy roassal presenters' }
IllAllocationProfilerUI >> allocationsPerSecondPerAllocatorPresenter [

	allocationsPerSecondPerAllocatorPresenter ifNil: [ self initializeAllocationsPerSecondPerAllocator ].
	^ allocationsPerSecondPerAllocatorPresenter
]

{ #category : 'accessing' }
IllAllocationProfilerUI >> codeEvaluatorText [
    ^ 'self objectAllocations.
self stats allocationsByMethod'
]

{ #category : 'initialization' }
IllAllocationProfilerUI >> connectPresenters [

	super connectPresenters.
	topCalculationsNumberInputPresenter whenNumberChangedDo: [ :newValue | topCalculationsNumber := newValue ]
]

{ #category : 'layout' }
IllAllocationProfilerUI >> controlButtonsLayout [

	^ super controlButtonsLayout
		  add: (SpBoxLayout newLeftToRight
				   spacing: 5;
				   add: 'Show visualizations for the top:' expand: false;
				   add: topCalculationsNumberInputPresenter width: 50;
				   yourself);
		  yourself
]

{ #category : 'accessing - lazy roassal presenters' }
IllAllocationProfilerUI >> heatMapPresenter [

	heatmapPresenter ifNil: [ self initializeHeatmapPresenter ].
	^ heatmapPresenter
]

{ #category : 'initialization - lazy roassal presenters' }
IllAllocationProfilerUI >> initializeAllocatedObjectsPerSecond [

	allocatedObjectsPerSecondPresenter := SpRoassalPresenter new
		canvas: (RoassaHelperChartBuilder new
			model: profiler;
			topCalculationsNumber: topCalculationsNumber;
			allocatedObjectsPerSecondLineChartCanvas);
		yourself
]

{ #category : 'initialization - lazy presenters' }
IllAllocationProfilerUI >> initializeAllocatedObjectsTablePresenter [

	allocatedObjectsTablePresenter := self
		instantiate: (AllocatedObjectsTablePresenter on: profiler objectAllocations)
]

{ #category : 'initialization - lazy roassal presenters' }
IllAllocationProfilerUI >> initializeAllocationsPerSecondPerAllocator [

	allocationsPerSecondPerAllocatorPresenter := SpRoassalPresenter new
		canvas: (RoassaHelperChartBuilder new
			model: profiler;
			topCalculationsNumber: topCalculationsNumber;
			allocatedObjectsPerSecondPerMethodLineChartCanvas);
		yourself
]

{ #category : 'initialization - lazy roassal presenters' }
IllAllocationProfilerUI >> initializeHeatmapPresenter [

	| roassalPresenterByMethod |
	roassalPresenterByMethod := self instantiate: SpRoassalPresenter.
	roassalPresenterByMethod canvas: (RoassaHelperChartBuilder new
		model: profiler;
		topCalculationsNumber: topCalculationsNumber;
		heatmapAllocatorAllocatedCanvasByMethod).

	heatmapPresenter := roassalPresenterByMethod
]

{ #category : 'initialization - lazy presenters' }
IllAllocationProfilerUI >> initializeMemoryTablePresenter [

	memoryTablePresenter := AllocationsByAllocatorTablePresenter
		owner: self
		on: profiler allocationsStats allocationsByMethod
]

{ #category : 'initialization' }
IllAllocationProfilerUI >> initializeNotebook [

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

{ #category : 'initialization' }
IllAllocationProfilerUI >> initializePresenters [

	super initializePresenters.
	self initializeTopCalculationsInputPresenter
]

{ #category : 'initialization' }
IllAllocationProfilerUI >> initializeTopCalculationsInputPresenter [

	topCalculationsNumber := 10.
	topCalculationsNumberInputPresenter := self newNumberInput
		number: topCalculationsNumber;
		minimum: 1;
		yourself
]

{ #category : 'accessing - lazy presenters' }
IllAllocationProfilerUI >> memoryTablePresenter [

	memoryTablePresenter ifNil: [ self initializeMemoryTablePresenter ].
	^ memoryTablePresenter
]

{ #category : 'initialization - lazy presenters' }
IllAllocationProfilerUI >> profilerSummaryPresenter [

	^ ProfilerSummaryPresenter on: profiler
]

{ #category : 'actions' }
IllAllocationProfilerUI >> refresh [

	heatmapPresenter := nil.
	allocationsPerSecondPerAllocatorPresenter := nil.
	allocatedObjectsPerSecondPresenter := nil.
	self layout: self defaultLayout
]

{ #category : 'initialization' }
IllAllocationProfilerUI >> title [

	^ 'Illimani Allocation Site Memory Profiler'
]
