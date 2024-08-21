Class {
	#name : 'IllObjectLifetimesProfilerUI',
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
IllObjectLifetimesProfilerUI >> avgLifetimesTablePresenter [

	avgLifetimesTablePresenter ifNil: [ self initializeAvgLifetimesTablePresenter ].
	^ avgLifetimesTablePresenter
]

{ #category : 'accessing' }
IllObjectLifetimesProfilerUI >> codeEvaluatorText [

	^ 'self objectAllocations'
]

{ #category : 'accessing - lazy presenters' }
IllObjectLifetimesProfilerUI >> frequencyHistogramPresenter [

	frequencyHistogramPresenter ifNil: [ self initializeFrequencyHistogramPresenter ].
	^ frequencyHistogramPresenter
]

{ #category : 'accessing - lazy presenters' }
IllObjectLifetimesProfilerUI >> gcCyclesTable [

	gcCyclesTable ifNil: [ self initializeGCCyclesTable ].
	^ gcCyclesTable
]

{ #category : 'initialization' }
IllObjectLifetimesProfilerUI >> initializeAvgLifetimesTablePresenter [

	avgLifetimesTablePresenter := ObjectLifetimesTablePresenter on: profiler
]

{ #category : 'initialization - lazy presenters' }
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

{ #category : 'initialization' }
IllObjectLifetimesProfilerUI >> initializeNotebook [

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
IllObjectLifetimesProfilerUI >> initializeRelativeFrequenciesTable [

	relativeFrequenciesTable := self
		instantiate: RelativeLifetimesBySecondTablePresenter
		on: profiler objectAllocations
]

{ #category : 'accessing - lazy presenters' }
IllObjectLifetimesProfilerUI >> lifetimesTable [

	relativeFrequenciesTable ifNil: [ self initializeRelativeFrequenciesTable ].
	^ relativeFrequenciesTable
]

{ #category : 'initialization - lazy presenters' }
IllObjectLifetimesProfilerUI >> profilerSummaryPresenter [

	^ ProfilerSummaryPresenter on: profiler
]

{ #category : 'actions' }
IllObjectLifetimesProfilerUI >> refresh [

	frequencyHistogramPresenter := nil.
	self layout: self defaultLayout
]

{ #category : 'initialization' }
IllObjectLifetimesProfilerUI >> title [

	^ 'Illimani Finalization Memory Profiler'
]
