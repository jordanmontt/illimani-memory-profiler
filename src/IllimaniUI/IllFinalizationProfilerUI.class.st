Class {
	#name : 'IllFinalizationProfilerUI',
	#superclass : 'IllAbstractUI',
	#instVars : [
		'gcCyclesTable',
		'frequencyHistogramPresenter',
		'relativeFrequenciesTable',
		'avgLifetimesTablePresenter'
	],
	#category : 'IllimaniUI-Main Presenter',
	#package : 'IllimaniUI',
	#tag : 'Main Presenter'
}

{ #category : 'initialization' }
IllFinalizationProfilerUI >> avgLifetimesTablePresenter [

	avgLifetimesTablePresenter ifNil: [ self initializeAvgLifetimesTablePresenter ].
	^ avgLifetimesTablePresenter
]

{ #category : 'accessing' }
IllFinalizationProfilerUI >> codeEvaluatorText [

	^ 'self objectAllocations'
]

{ #category : 'accessing - lazy presenters' }
IllFinalizationProfilerUI >> frequencyHistogramPresenter [

	frequencyHistogramPresenter ifNil: [ self initializeFrequencyHistogramPresenter ].
	^ frequencyHistogramPresenter
]

{ #category : 'accessing - lazy presenters' }
IllFinalizationProfilerUI >> gcCyclesTable [

	gcCyclesTable ifNil: [ self initializeGCCyclesTable ].
	^ gcCyclesTable
]

{ #category : 'initialization' }
IllFinalizationProfilerUI >> initializeAvgLifetimesTablePresenter [

	avgLifetimesTablePresenter := ObjectLifetimesTablePresenter on: profiler
]

{ #category : 'initialization - lazy presenters' }
IllFinalizationProfilerUI >> initializeFrequencyHistogramPresenter [

	frequencyHistogramPresenter := IllFrequencyHistogramPresenter on: profiler
]

{ #category : 'initialization - lazy presenters' }
IllFinalizationProfilerUI >> initializeGCCyclesTable [

	gcCyclesTable := AlternatorPresenter new
	   presenterTwo: (FinalizationScavengesCyclesTablePresenter on: profiler objectAllocations)
		withName: 'Group by scavenges';
		presenterOne: (FinalizationFullGCCyclesTablePresenter on: profiler objectAllocations)
		withName: 'Group by full GCs';
		yourself
]

{ #category : 'initialization' }
IllFinalizationProfilerUI >> initializeNotebook [

	notebookPresenter := self newNotebook
		addPageTitle: 'Summary' provider: [ self summaryAndEvaluatorPresenter ];
		addPageTitle: 'Avg Lifetimes' provider: [ self avgLifetimesTablePresenter ];
		addPageTitle: 'Survived GC cycles' provider: [ self gcCyclesTable ];
		addPageTitle: 'Relative Frequencies Table' provider: [ self lifetimesTable ];
		addPageTitle: 'Relative frequencies' provider: [ self frequencyHistogramPresenter ];
		
		addPageTitle: 'Evaluator' provider: [ self codeEvaluator ];
		yourself
]

{ #category : 'initialization - lazy presenters' }
IllFinalizationProfilerUI >> initializeRelativeFrequenciesTable [

	relativeFrequenciesTable := self
		instantiate: FinalizationLifetimesTablePresenter
		on: profiler objectAllocations
]

{ #category : 'accessing - lazy presenters' }
IllFinalizationProfilerUI >> lifetimesTable [

	relativeFrequenciesTable ifNil: [ self initializeRelativeFrequenciesTable ].
	^ relativeFrequenciesTable
]

{ #category : 'actions' }
IllFinalizationProfilerUI >> refresh [

	frequencyHistogramPresenter := nil.
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
