Class {
	#name : 'IllObjectLifetimesProfilerUI',
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
IllObjectLifetimesProfilerUI >> allocatedObjectsPerSecondPresenter [

	allocatedObjectsPerSecondPresenter ifNil: [ self initializeAllocatedObjectsPerSecond ].
	^ allocatedObjectsPerSecondPresenter
]

{ #category : 'accessing - lazy presenters' }
IllObjectLifetimesProfilerUI >> allocatedObjectsTablePresenter [

	allocatedObjectsTablePresenter ifNil: [ self initializeAllocatedObjectsTablePresenter ].
	^ allocatedObjectsTablePresenter
]

{ #category : 'accessing - lazy roassal presenters' }
IllObjectLifetimesProfilerUI >> allocationsPerSecondPerAllocatorPresenter [

	allocationsPerSecondPerAllocatorPresenter ifNil: [ self initializeAllocationsPerSecondPerAllocator ].
	^ allocationsPerSecondPerAllocatorPresenter
]

{ #category : 'accessing - lazy presenters' }
IllObjectLifetimesProfilerUI >> allocatorsTablePresenter [

	allocatorsTablePresenter ifNil: [ self initializeAllocatorsTablePresenter ].
	^ allocatorsTablePresenter
]

{ #category : 'accessing' }
IllObjectLifetimesProfilerUI >> codeEvaluatorText [

	^
'self objectAllocations.
self stats allocationsByMethod'
]

{ #category : 'accessing - lazy roassal presenters' }
IllObjectLifetimesProfilerUI >> frequencyHistogramPresenter [

	frequencyHistogramPresenter ifNil: [ self initializeFrequencyHistogramPresenter ].
	^ frequencyHistogramPresenter
]

{ #category : 'accessing - lazy presenters' }
IllObjectLifetimesProfilerUI >> gcCyclesTable [

	gcCyclesTable ifNil: [ self initializeGCCyclesTable ].
	^ gcCyclesTable
]

{ #category : 'accessing - lazy roassal presenters' }
IllObjectLifetimesProfilerUI >> heatMapPresenter [

	heatmapPresenter ifNil: [ self initializeHeatmapPresenter ].
	^ heatmapPresenter
]

{ #category : 'initialization - lazy roassal presenters' }
IllObjectLifetimesProfilerUI >> initializeAllocatedObjectsPerSecond [

	allocatedObjectsPerSecondPresenter := SpRoassalPresenter new
		canvas: (RoassaHelperChartBuilder new
			model: profiler;
			topCalculationsNumber: 10;
			allocatedObjectsPerSecondLineChartCanvas);
		yourself
]

{ #category : 'initialization - lazy presenters' }
IllObjectLifetimesProfilerUI >> initializeAllocatedObjectsTablePresenter [

	allocatedObjectsTablePresenter := ObjectLifetimesTablePresenter on: profiler
]

{ #category : 'initialization - lazy roassal presenters' }
IllObjectLifetimesProfilerUI >> initializeAllocationsPerSecondPerAllocator [

	allocationsPerSecondPerAllocatorPresenter := SpRoassalPresenter new
		canvas: (RoassaHelperChartBuilder new
			model: profiler;
			topCalculationsNumber: 10;
			allocatedObjectsPerSecondPerMethodLineChartCanvas);
		yourself
]

{ #category : 'initialization - lazy presenters' }
IllObjectLifetimesProfilerUI >> initializeAllocatorsTablePresenter [

	allocatorsTablePresenter := AllocationsByAllocatorTablePresenter
		owner: self
		on: profiler allocationsStats allocationsByMethod
]

{ #category : 'initialization - lazy roassal presenters' }
IllObjectLifetimesProfilerUI >> initializeFrequencyHistogramPresenter [

	frequencyHistogramPresenter := FrequencyHistogramRoassalPresenter on: profiler
]

{ #category : 'initialization - lazy presenters' }
IllObjectLifetimesProfilerUI >> initializeGCCyclesTable [

	gcCyclesTable := AlternatorPresenter new
	   presenterTwo: (RelativeLifetimesByScavengesTablePresenter on: profiler objectAllocations)
		withName: 'Group by scavenges';
		presenterOne: (RelativeLifetimesByFullGCsTablePresenter on: profiler objectAllocations)
		withName: 'Group by full GCs';
		yourself
]

{ #category : 'initialization - lazy roassal presenters' }
IllObjectLifetimesProfilerUI >> initializeHeatmapPresenter [

	| roassalPresenterByMethod |
	roassalPresenterByMethod := self instantiate: SpRoassalPresenter.
	roassalPresenterByMethod canvas: (RoassaHelperChartBuilder new
		model: profiler;
		topCalculationsNumber: 10;
		heatmapAllocatorAllocatedCanvasByMethod).

	heatmapPresenter := roassalPresenterByMethod
]

{ #category : 'initialization' }
IllObjectLifetimesProfilerUI >> initializeNotebook [

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
IllObjectLifetimesProfilerUI >> initializeRelativeLifetimesTable [

	relativeLifetimesTable := self
		instantiate: RelativeLifetimesBySecondTablePresenter
		on: profiler objectAllocations
]

{ #category : 'actions' }
IllObjectLifetimesProfilerUI >> refresh [

	frequencyHistogramPresenter := nil.
	self layout: self defaultLayout
]

{ #category : 'accessing - lazy presenters' }
IllObjectLifetimesProfilerUI >> relativeLifetimesTable [

	relativeLifetimesTable ifNil: [ self initializeRelativeLifetimesTable ].
	^ relativeLifetimesTable
]

{ #category : 'initialization' }
IllObjectLifetimesProfilerUI >> title [

	^ 'Illimani Memory Profiler'
]
