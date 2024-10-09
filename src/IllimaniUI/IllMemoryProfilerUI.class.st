Class {
	#name : 'IllMemoryProfilerUI',
	#superclass : 'IllAbstractUI',
	#instVars : [
		'gcCyclesTable',
		'frequencyHistogramPresenter',
		'allocatorsTablePresenter',
		'relativeLifetimesTable',
		'allocatedObjectsTablePresenter',
		'heatmapPresenter',
		'allocatedObjectsPerSecondPresenter',
		'allocationsPerSecondPerAllocatorPresenter'
	],
	#category : 'IllimaniUI-Main Presenter',
	#package : 'IllimaniUI',
	#tag : 'Main Presenter'
}

{ #category : 'accessing - lazy roassal presenters' }
IllMemoryProfilerUI >> allocatedObjectsPerSecondPresenter [

	allocatedObjectsPerSecondPresenter ifNil: [ self initializeAllocatedObjectsPerSecond ].
	^ allocatedObjectsPerSecondPresenter
]

{ #category : 'accessing - lazy presenters' }
IllMemoryProfilerUI >> allocatedObjectsTablePresenter [

	allocatedObjectsTablePresenter ifNil: [ self initializeAllocatedObjectsTablePresenter ].
	^ allocatedObjectsTablePresenter
]

{ #category : 'accessing - lazy roassal presenters' }
IllMemoryProfilerUI >> allocationsPerSecondPerAllocatorPresenter [

	allocationsPerSecondPerAllocatorPresenter ifNil: [ self initializeAllocationsPerSecondPerAllocator ].
	^ allocationsPerSecondPerAllocatorPresenter
]

{ #category : 'accessing - lazy presenters' }
IllMemoryProfilerUI >> allocatorsTablePresenter [

	allocatorsTablePresenter ifNil: [ self initializeAllocatorsTablePresenter ].
	^ allocatorsTablePresenter
]

{ #category : 'accessing' }
IllMemoryProfilerUI >> codeEvaluatorText [

	^
'self objectAllocations.
self allocationStats allocationsByMethod'
]

{ #category : 'accessing - lazy roassal presenters' }
IllMemoryProfilerUI >> frequencyHistogramPresenter [

	frequencyHistogramPresenter ifNil: [ self initializeFrequencyHistogramPresenter ].
	^ frequencyHistogramPresenter
]

{ #category : 'accessing - lazy presenters' }
IllMemoryProfilerUI >> gcCyclesTable [

	gcCyclesTable ifNil: [ self initializeGCCyclesTable ].
	^ gcCyclesTable
]

{ #category : 'accessing - lazy roassal presenters' }
IllMemoryProfilerUI >> heatMapPresenter [

	heatmapPresenter ifNil: [ self initializeHeatmapPresenter ].
	^ heatmapPresenter
]

{ #category : 'initialization - lazy roassal presenters' }
IllMemoryProfilerUI >> initializeAllocatedObjectsPerSecond [

	allocatedObjectsPerSecondPresenter := SpRoassalPresenter new
		canvas: (RoassaHelperChartBuilder new
			model: profiler;
			topCalculationsNumber: 10;
			allocatedObjectsPerSecondLineChartCanvas);
		yourself
]

{ #category : 'initialization - lazy presenters' }
IllMemoryProfilerUI >> initializeAllocatedObjectsTablePresenter [

	allocatedObjectsTablePresenter := AllocatedObjectsTablePresenter on: profiler
]

{ #category : 'initialization - lazy roassal presenters' }
IllMemoryProfilerUI >> initializeAllocationsPerSecondPerAllocator [

	allocationsPerSecondPerAllocatorPresenter := SpRoassalPresenter new
		canvas: (RoassaHelperChartBuilder new
			model: profiler;
			topCalculationsNumber: 10;
			allocatedObjectsPerSecondPerMethodLineChartCanvas);
		yourself
]

{ #category : 'initialization - lazy presenters' }
IllMemoryProfilerUI >> initializeAllocatorsTablePresenter [

	allocatorsTablePresenter := AllocationsByAllocatorTablePresenter
		owner: self
		on: profiler allocationStats allocationsByMethod
]

{ #category : 'initialization - lazy roassal presenters' }
IllMemoryProfilerUI >> initializeFrequencyHistogramPresenter [

	frequencyHistogramPresenter := FrequencyHistogramRoassalPresenter on: profiler
]

{ #category : 'initialization - lazy presenters' }
IllMemoryProfilerUI >> initializeGCCyclesTable [

	gcCyclesTable := AlternatorPresenter new
	   presenterTwo: (RelativeLifetimesByScavengesTablePresenter on: profiler objectAllocations)
		withName: 'Group by scavenges';
		presenterOne: (RelativeLifetimesByFullGCsTablePresenter on: profiler objectAllocations)
		withName: 'Group by full GCs';
		yourself
]

{ #category : 'initialization - lazy roassal presenters' }
IllMemoryProfilerUI >> initializeHeatmapPresenter [

	| roassalPresenterByMethod |
	roassalPresenterByMethod := self instantiate: SpRoassalPresenter.
	roassalPresenterByMethod canvas: (RoassaHelperChartBuilder new
		model: profiler;
		topCalculationsNumber: 10;
		heatmapAllocatorAllocatedCanvasByMethod).

	heatmapPresenter := roassalPresenterByMethod
]

{ #category : 'initialization' }
IllMemoryProfilerUI >> initializeNotebook [

	notebookPresenter := self newNotebook
		addPageTitle: 'Summary' provider: [ self summaryAndEvaluatorPresenter ];
		addPageTitle: 'Allocated objects' provider: [ self allocatedObjectsTablePresenter ];
		addPageTitle: 'Allocation sites' provider: [ self allocatorsTablePresenter ];
		addPageTitle: 'Survived GC cycles' provider: [ self gcCyclesTable ];
		addPageTitle: 'Grouped lifetimes' provider: [ self relativeLifetimesTable ];
		
		addPageTitle: 'Lifetimes histogram' provider: [ self frequencyHistogramPresenter ];
		addPageTitle: 'Heatmap' provider: [ self heatMapPresenter ];
		addPageTitle: 'Allocations in time' provider: [ self allocatedObjectsPerSecondPresenter ];
		addPageTitle: 'Allocations per allocator' provider: [ self allocationsPerSecondPerAllocatorPresenter ];
		
		addPageTitle: 'Evaluator' provider: [ self codeEvaluator ];
		yourself
]

{ #category : 'initialization - lazy presenters' }
IllMemoryProfilerUI >> initializeRelativeLifetimesTable [

	relativeLifetimesTable := self
		instantiate: RelativeLifetimesByMBTablePresenter
		on: profiler objectAllocations
]

{ #category : 'actions' }
IllMemoryProfilerUI >> refresh [

	frequencyHistogramPresenter := nil.
	self layout: self defaultLayout
]

{ #category : 'accessing - lazy presenters' }
IllMemoryProfilerUI >> relativeLifetimesTable [

	relativeLifetimesTable ifNil: [ self initializeRelativeLifetimesTable ].
	^ relativeLifetimesTable
]
