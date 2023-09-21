Class {
	#name : 'IllFinalizationProfilerUI',
	#superclass : 'IllAbstractUI',
	#instVars : [
		'densityChartPresenter',
		'lifetimesTable'
	],
	#category : 'IllimaniAllocationProfiler-UI-Main Presenter',
	#package : 'IllimaniAllocationProfiler-UI',
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
	densityPlotBuilder := IllDensityDistributionChart new
		objectAllocations: profiler objectAllocations;
		xTitle: 'Lifetime in seconds';
		yourself.
	densityChartByMemory := densityPlotBuilder
		beForMemory;
		yTitle: 'Memory';
		"yLog: true;"
		densityChartPresenter.
	densityChartByNumbOfAlloc := densityPlotBuilder
		beForNumberOfAllocations;
		yTitle: 'Number of allocations';
		"yLog: true;"
		densityChartPresenter.

	densityChartPresenter := AlternatorPresenter new
	   presenterOne: densityChartByMemory withName: 'memory';
		presenterTwo: densityChartByNumbOfAlloc withName: 'number of allocations';
		yourself
]

{ #category : 'initialization - lazy presenters' }
IllFinalizationProfilerUI >> initializeLifetimesTable [

	lifetimesTable := self
		instantiate: FinalizationLifetimesTablePresenter
		on: profiler objectAllocations
]

{ #category : 'initialization - lazy presenters' }
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

	self layout: self defaultLayout.
	densityChartPresenter := nil
]

{ #category : 'initialization - lazy presenters' }
IllFinalizationProfilerUI >> summaryStatsPresenter [

	^ BasicAllocationSummaryPresenter on: profiler
]

{ #category : 'initialization' }
IllFinalizationProfilerUI >> title [

	^ 'Illimani Finalization Memory Profiler'
]
