Class {
	#name : 'IllFinalizationProfilerUI',
	#superclass : 'IllAbstractUI',
	#instVars : [
		'densityChartPresenter',
		'lifetimesTable'
	],
	#category : 'IllimaniUI-Main Presenter',
	#package : 'IllimaniUI',
	#tag : 'Main Presenter'
}

{ #category : 'accessing' }
IllFinalizationProfilerUI >> codeEvaluatorText [

	^ 'self objectAllocations'
]

{ #category : 'accessing - lazy presenters' }
IllFinalizationProfilerUI >> densityChartPresenter [

	densityChartPresenter ifNil: [ self initializeDensityChartPresenter ].
	^ densityChartPresenter
]

{ #category : 'initialization - lazy presenters' }
IllFinalizationProfilerUI >> initializeDensityChartPresenter [

	| densityPlotBuilder densityChartByMemory densityChartByNumbOfAlloc |
	densityPlotBuilder := IllDensityDistributionChartBuilder new
		objectAllocations: profiler objectAllocations;
		xTitle: 'Lifetime in seconds';
		yourself.
	densityChartByMemory := densityPlotBuilder
		beForMemory;
		yTitle: 'Memory';
		"yLog: true;"
		buildDensityChartPresenter.
	densityChartByNumbOfAlloc := densityPlotBuilder
		beForNumberOfAllocations;
		yTitle: 'Number of allocations';
		"yLog: true;"
		buildDensityChartPresenter.

	densityChartPresenter := AlternatorPresenter new
	   presenterOne: densityChartByMemory withName: 'Group by memory';
		presenterTwo: densityChartByNumbOfAlloc withName: 'Group by number of allocations';
		yourself
]

{ #category : 'initialization - lazy presenters' }
IllFinalizationProfilerUI >> initializeLifetimesTable [

	lifetimesTable := self
		instantiate: FinalizationLifetimesTablePresenter
		on: profiler objectAllocations
]

{ #category : 'initialization' }
IllFinalizationProfilerUI >> initializeNotebook [

	notebookPresenter := self newNotebook
		addPageTitle: 'Summary' provider: [ self summaryAndEvaluatorPresenter ];
		addPageTitle: 'Allocated Objects' provider: [ self allocatedObjectsTablePresenter ];
		addPageTitle: 'Lifetimes Table' provider: [ self lifetimesTable ];
		addPageTitle: 'Lifetimes Density' provider: [ self densityChartPresenter ];

		addPageTitle: 'Evaluator' provider: [ self codeEvaluator ];
		yourself
]

{ #category : 'accessing - lazy presenters' }
IllFinalizationProfilerUI >> lifetimesTable [

	lifetimesTable ifNil: [ self initializeLifetimesTable ].
	^ lifetimesTable
]

{ #category : 'actions' }
IllFinalizationProfilerUI >> refresh [

	densityChartPresenter := nil.
	self layout: self defaultLayout
]

{ #category : 'initialization - lazy presenters' }
IllFinalizationProfilerUI >> summaryStatsPresenter [

	^ AllocationSummaryPresenter on: profiler
]

{ #category : 'initialization' }
IllFinalizationProfilerUI >> title [

	^ 'Illimani Finalization Memory Profiler'
]
