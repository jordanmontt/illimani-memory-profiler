Class {
	#name : 'IllFinalizationProfilerUI',
	#superclass : 'IllAbstractUI',
	#classTraits : '{} + TraitedClass',
	#instVars : [
		'lifetimesTable',
		'gcCyclesTable',
		'frequencyHistogramPresenter'
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
IllFinalizationProfilerUI >> frequencyHistogramPresenter [

	frequencyHistogramPresenter ifNil: [ self initializeFrequencyHistogramPresenter ].
	^ frequencyHistogramPresenter
]

{ #category : 'accessing - lazy presenters' }
IllFinalizationProfilerUI >> gcCyclesTable [

	gcCyclesTable ifNil: [ self initializeGCCyclesTable ].
	^ gcCyclesTable
]

{ #category : 'initialization - lazy presenters' }
IllFinalizationProfilerUI >> initializeFrequencyHistogramPresenter [

	frequencyHistogramPresenter := IllFrequencyHistogramPresenter on: profiler
]

{ #category : 'initialization - lazy presenters' }
IllFinalizationProfilerUI >> initializeGCCyclesTable [

	gcCyclesTable := AlternatorPresenter new
	   presenterOne: (FinalizationScavengesCyclesTablePresenter on: profiler objectAllocations)
		withName: 'Group by scavenges';
		presenterTwo: (FinalizationFullGCCyclesTablePresenter on: profiler objectAllocations)
		withName: 'Group by full GCs';
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
		addPageTitle: 'Lifetimes table' provider: [ self lifetimesTable ];
		addPageTitle: 'Survived GC cycles' provider: [ self gcCyclesTable ];
		addPageTitle: 'Allocated objects' provider: [ self allocatedObjectsTablePresenter ];
		addPageTitle: 'Relative frequencies' provider: [ self frequencyHistogramPresenter ];

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
