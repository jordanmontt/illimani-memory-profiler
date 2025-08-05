Class {
	#name : 'FiLiPUI',
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
	#category : 'FiLiP-MemoryProfiler-UI',
	#package : 'FiLiP-MemoryProfiler-UI'
}

{ #category : 'accessing - lazy roassal presenters' }
FiLiPUI >> allocatedObjectsPerSecondPresenter [

	allocatedObjectsPerSecondPresenter ifNil: [ self initializeAllocatedObjectsPerSecond ].
	^ allocatedObjectsPerSecondPresenter
]

{ #category : 'accessing - lazy presenters' }
FiLiPUI >> allocatedObjectsTablePresenter [

	allocatedObjectsTablePresenter ifNil: [ self initializeAllocatedObjectsTablePresenter ].
	^ allocatedObjectsTablePresenter
]

{ #category : 'accessing - lazy roassal presenters' }
FiLiPUI >> allocationsPerSecondPerAllocatorPresenter [

	allocationsPerSecondPerAllocatorPresenter ifNil: [ self initializeAllocationsPerSecondPerAllocator ].
	^ allocationsPerSecondPerAllocatorPresenter
]

{ #category : 'accessing - lazy presenters' }
FiLiPUI >> allocatorsTablePresenter [

	allocatorsTablePresenter ifNil: [ self initializeAllocatorsTablePresenter ].
	^ allocatorsTablePresenter
]

{ #category : 'accessing' }
FiLiPUI >> codeEvaluatorText [

	^
'self objectAllocations.
self queryAllocationStats allocationsByAllocationSite.
self queryAllocationStats allocationsByAllocatedObject'
]

{ #category : 'accessing - lazy roassal presenters' }
FiLiPUI >> frequencyHistogramPresenter [

	frequencyHistogramPresenter ifNil: [ self initializeFrequencyHistogramPresenter ].
	^ frequencyHistogramPresenter
]

{ #category : 'accessing - lazy presenters' }
FiLiPUI >> gcCyclesTable [

	gcCyclesTable ifNil: [ self initializeGCCyclesTable ].
	^ gcCyclesTable
]

{ #category : 'accessing - lazy roassal presenters' }
FiLiPUI >> heatMapPresenter [

	heatmapPresenter ifNil: [ self initializeHeatmapPresenter ].
	^ heatmapPresenter
]

{ #category : 'initialization - lazy roassal presenters' }
FiLiPUI >> initializeAllocatedObjectsPerSecond [

	allocatedObjectsPerSecondPresenter := SpRoassalPresenter new
		canvas: (RoassaHelperChartBuilder new
			model: profiler;
			topCalculationsNumber: 10;
			allocatedObjectsPerSecondLineChartCanvas);
		yourself
]

{ #category : 'initialization - lazy presenters' }
FiLiPUI >> initializeAllocatedObjectsTablePresenter [

	allocatedObjectsTablePresenter := AllocatedObjectsTablePresenter on: profiler
]

{ #category : 'initialization - lazy roassal presenters' }
FiLiPUI >> initializeAllocationsPerSecondPerAllocator [

	allocationsPerSecondPerAllocatorPresenter := SpRoassalPresenter new
		canvas: (RoassaHelperChartBuilder new
			model: profiler;
			topCalculationsNumber: 10;
			allocatedObjectsPerSecondPerMethodLineChartCanvas);
		yourself
]

{ #category : 'initialization - lazy presenters' }
FiLiPUI >> initializeAllocatorsTablePresenter [

	allocatorsTablePresenter := AllocationsByAllocatorTablePresenter
		owner: self
		on: profiler queryAllocationStats allocationsByAllocationSite
]

{ #category : 'initialization - lazy roassal presenters' }
FiLiPUI >> initializeFrequencyHistogramPresenter [

	frequencyHistogramPresenter := FrequencyHistogramRoassalPresenter on: profiler
]

{ #category : 'initialization - lazy presenters' }
FiLiPUI >> initializeGCCyclesTable [

	gcCyclesTable := AlternatorPresenter new
	   presenterTwo: (RelativeLifetimesByScavengesTablePresenter on: profiler objectAllocations)
		withName: 'Group by scavenges';
		presenterOne: (RelativeLifetimesByFullGCsTablePresenter on: profiler objectAllocations)
		withName: 'Group by full GCs';
		yourself
]

{ #category : 'initialization - lazy roassal presenters' }
FiLiPUI >> initializeHeatmapPresenter [

	| roassalPresenterByMethod |
	roassalPresenterByMethod := self instantiate: SpRoassalPresenter.
	roassalPresenterByMethod canvas: (RoassaHelperChartBuilder new
		model: profiler;
		topCalculationsNumber: 10;
		heatmapAllocatorAllocatedCanvasByMethod).

	heatmapPresenter := roassalPresenterByMethod
]

{ #category : 'initialization' }
FiLiPUI >> initializeNotebook [

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
FiLiPUI >> initializeRelativeLifetimesTable [

	relativeLifetimesTable := self
		instantiate: RelativeLifetimesByMBTablePresenter
		on: profiler objectAllocations
]

{ #category : 'initialization - lazy presenters' }
FiLiPUI >> profilerSummaryPresenter [

	^ SummaryFiLiPPresenter on: profiler
]

{ #category : 'actions' }
FiLiPUI >> refresh [

	frequencyHistogramPresenter := nil.
	self layout: self defaultLayout
]

{ #category : 'accessing - lazy presenters' }
FiLiPUI >> relativeLifetimesTable [

	relativeLifetimesTable ifNil: [ self initializeRelativeLifetimesTable ].
	^ relativeLifetimesTable
]
