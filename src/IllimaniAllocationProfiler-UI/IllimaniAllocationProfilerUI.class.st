"
I am a user interface for my profiling. My implementation is independent from the one of my profiler.
"
Class {
	#name : #IllimaniAllocationProfilerUI,
	#superclass : #SpPresenter,
	#instVars : [
		'notebookPresenter',
		'refreshButton',
		'toolbarPresenter',
		'allocatedObjectsPerSecondPresenter',
		'codeEvaluator',
		'heatmapPresenter',
		'topCalculationsNumberInputPresenter',
		'topCalculationsNumber',
		'summaryAndEvaluatorPresenter',
		'profiler',
		'memoryTablePresenter',
		'allocationsPerSecondPerAllocatorPresenter',
		'allocatedObjectsTablePresenter',
		'illimaniAnnouncer',
		'palu4'
	],
	#category : #'IllimaniAllocationProfiler-UI-Main Presenter'
}

{ #category : #accessing }
IllimaniAllocationProfilerUI class >> illimaniAnnouncer: anIllimaniAnnouncer [

	^ self basicNew
		illimaniAnnouncer: anIllimaniAnnouncer;
		initialize
]

{ #category : #accessing }
IllimaniAllocationProfilerUI >> allocatedObjectsPerSecondPerClassPresenter [

	^ SpRoassalPresenter new
		canvas: (IllimaniRoassalChartBuilder new
			model: profiler;
			topCalculationsNumber: topCalculationsNumber;
			allocatedObjectsPerSecondPerClassLineChartCanvas);
		yourself
]

{ #category : #accessing }
IllimaniAllocationProfilerUI >> allocatedObjectsPerSecondPerMethodPresenter [

	^ SpRoassalPresenter new
		canvas: (IllimaniRoassalChartBuilder new
			model: profiler;
			topCalculationsNumber: topCalculationsNumber;
			allocatedObjectsPerSecondPerMethodLineChartCanvas);
		yourself
]

{ #category : #'accessing - lazy presenters' }
IllimaniAllocationProfilerUI >> allocatedObjectsPerSecondPresenter [

	allocatedObjectsPerSecondPresenter ifNil: [ self initializeAllocatedObjectsPerSecond ].
	^ allocatedObjectsPerSecondPresenter
]

{ #category : #'accessing - lazy presenters' }
IllimaniAllocationProfilerUI >> allocatedObjectsTablePresenter [

	allocatedObjectsTablePresenter ifNil: [ self initializeAllocatedObjectsTablePresenter ].
	^ allocatedObjectsTablePresenter
]

{ #category : #'accessing - lazy presenters' }
IllimaniAllocationProfilerUI >> allocationsPerSecondPerAllocatorPresenter [

	allocationsPerSecondPerAllocatorPresenter ifNil: [ self initializeAllocationsPerSecondPerAllocator ].
	^ allocationsPerSecondPerAllocatorPresenter
]

{ #category : #'accessing - lazy presenters' }
IllimaniAllocationProfilerUI >> codeEvaluator [

	codeEvaluator ifNil: [ self initializeCodeEvaluator ].
	^ codeEvaluator
]

{ #category : #initialization }
IllimaniAllocationProfilerUI >> connectPresenters [

	refreshButton action: [ self refresh ].
	topCalculationsNumberInputPresenter whenNumberChangedDo: [ :newValue |
		topCalculationsNumber := newValue ]
]

{ #category : #layout }
IllimaniAllocationProfilerUI >> controlButtonsLayout [

	^ SpBoxLayout newTopToBottom
		  spacing: 5;
		  add: toolbarPresenter expand: false;
		  add: (SpBoxLayout newLeftToRight
				   spacing: 5;
				   add: 'Show visualizations for the top:' expand: false;
				   add: topCalculationsNumberInputPresenter width: 50;
				   yourself);
		  yourself
]

{ #category : #layout }
IllimaniAllocationProfilerUI >> defaultLayout [

	^ (profiler isNil or: [ profiler isProfilingStarted not ])
		  ifTrue: [ self layoutWhenThereIsNotDataWithMessage: 'Profiler backend not set or not it didn''t start to profile.' ]
		  ifFalse: [ self layoutWhenThereIsAProfiler ]
]

{ #category : #'accessing - lazy presenters' }
IllimaniAllocationProfilerUI >> heatMapPresenter [

	heatmapPresenter ifNil: [ self initializeHeatmapPresenter ].
	^ heatmapPresenter
]

{ #category : #accessing }
IllimaniAllocationProfilerUI >> illimaniAnnouncer: aIllimaniAnnouncer [

	illimaniAnnouncer := aIllimaniAnnouncer
]

{ #category : #'initialization - lazy presenters' }
IllimaniAllocationProfilerUI >> initializeAllocatedObjectsPerSecond [

	allocatedObjectsPerSecondPresenter := SpRoassalPresenter new
		canvas: (IllimaniRoassalChartBuilder new
			model: profiler;
			topCalculationsNumber: topCalculationsNumber;
			allocatedObjectsPerSecondLineChartCanvas);
		yourself
]

{ #category : #'initialization - lazy presenters' }
IllimaniAllocationProfilerUI >> initializeAllocatedObjectsTablePresenter [

	allocatedObjectsTablePresenter := self instantiate: (AllocatedObjectsTablePresenter on: profiler objectAllocations)
]

{ #category : #'initialization - lazy presenters' }
IllimaniAllocationProfilerUI >> initializeAllocationsPerSecondPerAllocator [

	allocationsPerSecondPerAllocatorPresenter := AlternatorPresenter new
		  presenterOne: self allocatedObjectsPerSecondPerClassPresenter withName: 'Classes';
		  presenterTwo: self allocatedObjectsPerSecondPerMethodPresenter withName: 'Methods';
		  yourself
]

{ #category : #'initialization - lazy presenters' }
IllimaniAllocationProfilerUI >> initializeCodeEvaluator [

	codeEvaluator := self newCode
		text: 'self objectAllocations.
self stats allocationsByClass.
self stats allocationsByMethod';
		beForObject: profiler;
		yourself
]

{ #category : #'initialization - lazy presenters' }
IllimaniAllocationProfilerUI >> initializeHeatmapPresenter [

	| roassalPresenterByClass roassalPresenterByMethod |
	roassalPresenterByClass := self instantiate: SpRoassalPresenter.
	roassalPresenterByClass canvas: (IllimaniRoassalChartBuilder new
			 model: profiler;
			 topCalculationsNumber: topCalculationsNumber;
			 heatmapAllocatorAllocatedCanvasByClass).
	roassalPresenterByMethod := self instantiate: SpRoassalPresenter.
	roassalPresenterByMethod canvas: (IllimaniRoassalChartBuilder new
			 model: profiler;
			 topCalculationsNumber: topCalculationsNumber;
			 heatmapAllocatorAllocatedCanvasByMethod).

	heatmapPresenter :=( self instantiate: AlternatorPresenter)
		presenterOne: roassalPresenterByClass withName: 'Classes';
		presenterTwo: roassalPresenterByMethod  withName: 'Methods';
		yourself
]

{ #category : #'initialization - lazy presenters' }
IllimaniAllocationProfilerUI >> initializeMemoryTablePresenter [

	memoryTablePresenter := AlternatorPresenter new
		presenterOne: (TableMemoryInformationPresenter owner: self on: profiler stats allocationsByClass)
		withName: 'Classes';
		presenterTwo: (TableMemoryInformationPresenter owner: self on: profiler stats allocationsByMethod)
		withName: 'Methods';
		yourself
]

{ #category : #'initialization - lazy presenters' }
IllimaniAllocationProfilerUI >> initializeNotebook [

	notebookPresenter := self newNotebook
		addPageTitle: 'Summary' provider: [ self summaryAndEvaluatorPresenter ];
		addPageTitle: 'Memory' provider: [ self memoryTablePresenter  ];
		addPageTitle: 'Allocated Objects' provider: [ self allocatedObjectsTablePresenter ];
		addPageTitle: 'Heatmap' provider: [ self heatMapPresenter ];
		addPageTitle: 'Palu4' provider: [ self palu4 ];
		addPageTitle: 'Allocations per Second Total'
		provider: [ self allocatedObjectsPerSecondPresenter ];
		addPageTitle: 'Allocations per Second per Allocator'
		provider: [ self allocationsPerSecondPerAllocatorPresenter ];

		addPageTitle: 'Evaluator' provider: [ self codeEvaluator ];
		yourself
]

{ #category : #'initialization - lazy presenters' }
IllimaniAllocationProfilerUI >> initializePalu4 [

	^ IllimaniDistributionForFinalization new
		  data: profiler objectAllocations;
		  groupingBlock: [ :allocationModel | (Duration milliSeconds:allocationModel initializationTimestamp) asDeciSeconds ceiling ];
		  applyGroupData;
		  palu4
]

{ #category : #initialization }
IllimaniAllocationProfilerUI >> initializePresenters [

	topCalculationsNumber := 10.
	self initializeToolbar.
	self initializeTopCalculationsInputPresenter.
	self respondToAnnouncement
]

{ #category : #'initialization - lazy presenters' }
IllimaniAllocationProfilerUI >> initializeRoassalPresenters [

	self initializeAllocatedObjectsPerSecond.
	self initializeAllocationsPerSecondPerAllocator.
	self initializeHeatmapPresenter
]

{ #category : #'initialization - lazy presenters' }
IllimaniAllocationProfilerUI >> initializeSummaryAndEvaluatorPresenter [

	| statsAndEvaluatorLayout statsPresenter |
	statsPresenter := AllocationSummaryPresenter on: profiler.

	statsAndEvaluatorLayout := SpPanedLayout newTopToBottom
		positionOfSlider: 0.75;
		add: statsPresenter;
		add: self codeEvaluator;
		yourself.

	summaryAndEvaluatorPresenter := SpPresenter new
		layout: statsAndEvaluatorLayout ;
		yourself
]

{ #category : #initialization }
IllimaniAllocationProfilerUI >> initializeToolbar [

	refreshButton := self newToolbarButton
		label: 'Refresh views';
		icon: (self iconNamed: #smallUpdate);
		yourself.
	toolbarPresenter := self newToolbar
		beBoth;
		addItemLeft: refreshButton;
		yourself
]

{ #category : #initialization }
IllimaniAllocationProfilerUI >> initializeTopCalculationsInputPresenter [

	topCalculationsNumberInputPresenter := self newNumberInput
		number: topCalculationsNumber;
		minimum: 1;
		yourself
]

{ #category : #initialization }
IllimaniAllocationProfilerUI >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Illimani Memory Profiler';
		initialExtent: 1000 @ 650
]

{ #category : #layout }
IllimaniAllocationProfilerUI >> layoutWhenThereIsAProfiler [

	| layoutToReturn |
	(profiler isProfilingStarted and: [
		 profiler isProfilingFinished not ]) ifTrue: [
		layoutToReturn := self layoutWhenThereIsNotDataWithMessage: 'Still profiling' ].

	(profiler isProfilingFinished and: [
		 profiler objectAllocations isEmpty ]) ifTrue: [
		layoutToReturn := self layoutWhenThereIsNotDataWithMessage: 'Profiling finished without any allocations. No allocations were produced during this profiling' ].

	(profiler isProfilingFinished and: [
		 profiler objectAllocations isNotEmpty ]) ifTrue: [
		layoutToReturn := self layoutWhenThereIsData ].

	^ layoutToReturn
]

{ #category : #layout }
IllimaniAllocationProfilerUI >> layoutWhenThereIsData [

	^ SpBoxLayout newTopToBottom
		add: self controlButtonsLayout expand: false;
		add: self notebookPresenter;
		yourself
]

{ #category : #layout }
IllimaniAllocationProfilerUI >> layoutWhenThereIsNotDataWithMessage: aString [

	^ SpBoxLayout newTopToBottom
		  add: self controlButtonsLayout expand: false;
		  add: (SpBoxLayout newTopToBottom
				   vAlignCenter;
				   hAlignCenter;
				   add: aString;
				   yourself);
		  yourself
]

{ #category : #'accessing - lazy presenters' }
IllimaniAllocationProfilerUI >> memoryTablePresenter [

	memoryTablePresenter ifNil: [ self initializeMemoryTablePresenter ].
	^ memoryTablePresenter
]

{ #category : #'accessing - lazy presenters' }
IllimaniAllocationProfilerUI >> notebookPresenter [

	notebookPresenter ifNil: [ self initializeNotebook ].
	^ notebookPresenter
]

{ #category : #accessing }
IllimaniAllocationProfilerUI >> objectAllocationProfiler: aProfiler [

	profiler := aProfiler
]

{ #category : #'accessing - lazy presenters' }
IllimaniAllocationProfilerUI >> palu4 [

	palu4 ifNil: [ self initializePalu4 ].
	^ palu4
]

{ #category : #actions }
IllimaniAllocationProfilerUI >> refresh [

	self initializeRoassalPresenters.
	self layout: self defaultLayout
]

{ #category : #announcements }
IllimaniAllocationProfilerUI >> respondToAnnouncement [

	illimaniAnnouncer when: IllimaniStopedProfilingAnnouncement
		do: [ self refresh ]
		for: self
]

{ #category : #'accessing - lazy presenters' }
IllimaniAllocationProfilerUI >> summaryAndEvaluatorPresenter [

	summaryAndEvaluatorPresenter ifNil: [ self initializeSummaryAndEvaluatorPresenter ].
	^ summaryAndEvaluatorPresenter
]
