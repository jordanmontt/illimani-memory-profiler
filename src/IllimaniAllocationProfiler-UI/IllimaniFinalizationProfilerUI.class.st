Class {
	#name : 'IllimaniFinalizationProfilerUI',
	#superclass : 'IllimaniAbstractUI',
	#instVars : [
		'densityChartPresenter',
		'lifetimesTable'
	],
	#category : 'IllimaniAllocationProfiler-UI-Main Presenter',
	#package : 'IllimaniAllocationProfiler-UI',
	#tag : 'Main Presenter'
}

{ #category : 'accessing' }
IllimaniFinalizationProfilerUI >> codeEvaluatorText [

	^ 'self objectAllocations'
]

{ #category : 'accessing - lazy presenters' }
IllimaniFinalizationProfilerUI >> densityChartPresenter [

	densityChartPresenter ifNil: [ self initializeDensityChartPresenter ].
	^ densityChartPresenter
]

{ #category : 'initialization - lazy presenters' }
IllimaniFinalizationProfilerUI >> initializeDensityChartPresenter [

	| densityPlotBuilder densityChartByMemory densityChartByNumbOfAlloc |
	densityPlotBuilder := IllimaniDensityDistributionChart new
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
IllimaniFinalizationProfilerUI >> initializeLifetimesTable [

	lifetimesTable := self
		instantiate: FinalizationLifetimesTablePresenter
		on: profiler objectAllocations
]

{ #category : 'initialization - lazy presenters' }
IllimaniFinalizationProfilerUI >> initializeNotebook [

	notebookPresenter := self newNotebook
		addPageTitle: 'Summary' provider: [ self summaryAndEvaluatorPresenter ];
		addPageTitle: 'Allocated Objects' provider: [ self allocatedObjectsTablePresenter ];
		addPageTitle: 'Lifetimes Table' provider: [ self lifetimesTable ];
		addPageTitle: 'Lifetimes Density' provider: [ self densityChartPresenter ];

		addPageTitle: 'Evaluator' provider: [ self codeEvaluator ];
		yourself
]

{ #category : 'accessing - lazy presenters' }
IllimaniFinalizationProfilerUI >> lifetimesTable [

	lifetimesTable ifNil: [ self initializeLifetimesTable ].
	^ lifetimesTable
]

{ #category : 'actions' }
IllimaniFinalizationProfilerUI >> refresh [

	self layout: self defaultLayout.
	densityChartPresenter := nil
]

{ #category : 'initialization - lazy presenters' }
IllimaniFinalizationProfilerUI >> summaryStatsPresenter [

	^ BasicAllocationSummaryPresenter on: profiler
]

{ #category : 'initialization' }
IllimaniFinalizationProfilerUI >> title [

	^ 'Illimani Finalization Memory Profiler'
]
