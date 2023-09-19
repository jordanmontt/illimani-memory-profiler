Class {
	#name : 'IllimaniFinalizationProfilerUI',
	#superclass : 'IllimaniAbstractUI',
	#instVars : [
		'densityChartPresenter'
	],
	#category : 'IllimaniAllocationProfiler-UI-Main Presenter',
	#package : 'IllimaniAllocationProfiler-UI',
	#tag : 'Main Presenter'
}

{ #category : 'accessing' }
IllimaniFinalizationProfilerUI >> codeEvaluatorText [

	^ 'self objectAllocations'
]

{ #category : 'accessing' }
IllimaniFinalizationProfilerUI >> densityChartPresenter [

	densityChartPresenter ifNil: [ self initializeDensityChartPresenter ].
	^ densityChartPresenter
]

{ #category : 'initialization - lazy presenters' }
IllimaniFinalizationProfilerUI >> initializeDensityChartPresenter [

	|  groupedDataByTime x dictionary yByMemory yByNumbOfAlloc densityChartByMemory densityChartByNumbOfAlloc |
	groupedDataByTime := (profiler objectAllocations groupedBy: [ :allocationModel |
		allocationModel lifetimeAsDuration asSeconds ]) associations.
	groupedDataByTime sort: [ :a :b | a key < b key ].
	x := 0 to: groupedDataByTime last key asInteger.
	
	dictionary := Dictionary newFrom: groupedDataByTime.
	yByNumbOfAlloc := x collect: [ :index |
		dictionary at: index
			ifPresent: [ :collection | collection size ]
			ifAbsent: [ 0 ] ].
		
	dictionary := Dictionary newFrom: groupedDataByTime.
	yByMemory := x collect: [ :index |
		dictionary at: index
			ifPresent: [ :collection | collection sum: #totalSizeInBytes ]
			ifAbsent: [ 0 ] ].

	densityChartByMemory := IllimaniDensityDistributionChart new
		x: x;
		y: yByMemory;
		xTitle: 'Lifetime in seconds';
		yTitle: 'Memory (log scale)';
		densityChartPresenter.
	densityChartByNumbOfAlloc := IllimaniDensityDistributionChart new
		x: x;
		y: yByNumbOfAlloc;
		isMemoryChart: false;
		xTitle: 'Lifetime in seconds';
		yTitle: 'Number of objects (log scale)';
		densityChartPresenter.
	
	densityChartPresenter := AlternatorPresenter new
	   presenterOne: densityChartByMemory withName: 'memory';
		presenterTwo: densityChartByNumbOfAlloc withName: 'number of allocations';
		yourself
]

{ #category : 'initialization - lazy presenters' }
IllimaniFinalizationProfilerUI >> initializeNotebook [

	notebookPresenter := self newNotebook
		addPageTitle: 'Summary' provider: [ self summaryAndEvaluatorPresenter ];
		addPageTitle: 'Allocated Objects' provider: [ self allocatedObjectsTablePresenter ];
		addPageTitle: 'Lifetimes Density' provider: [ self densityChartPresenter ];

		addPageTitle: 'Evaluator' provider: [ self codeEvaluator ];
		yourself
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
