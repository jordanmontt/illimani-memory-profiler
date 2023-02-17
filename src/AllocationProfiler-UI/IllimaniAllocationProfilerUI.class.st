"
I am a user interface for my profiling. My implementation is independent from the one of my profiler.
"
Class {
	#name : #IllimaniAllocationProfilerUI,
	#superclass : #SpPresenter,
	#instVars : [
		'notebookPresenter',
		'objectAllocationProfiler',
		'refreshButton',
		'toolbarPresenter',
		'allocatedObjectsPerSecondPresenter',
		'allocatedObjectsPerSecondPerClass',
		'codeEvaluator',
		'topClassesPresenter',
		'topMethodsPresenter',
		'heatmapPresenter',
		'topCalculationsNumberInputPresenter',
		'topCalculationsNumber',
		'topAllocatorsPresenter',
		'summaryAndEvaluatorPresenter'
	],
	#category : #'AllocationProfiler-UI'
}

{ #category : #'accessing - lazy presenters' }
IllimaniAllocationProfilerUI >> allocatedObjectsPerSecondPerClass [

	allocatedObjectsPerSecondPerClass ifNil: [ self initializeAllocatedObjectsPerSecondPerClass ].
	^ allocatedObjectsPerSecondPerClass
]

{ #category : #'accessing - lazy presenters' }
IllimaniAllocationProfilerUI >> allocatedObjectsPerSecondPresenter [

	allocatedObjectsPerSecondPresenter ifNil: [ self initializeAllocatedObjectsPerSecond ].
	^ allocatedObjectsPerSecondPresenter
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

	^ (objectAllocationProfiler isNil or: [ objectAllocationProfiler isProfilingStarted not ])
		  ifTrue: [ self layoutWhenThereIsNotDataWithMessage: 'Profiler backend not set or not it didn''t start to profile.' ]
		  ifFalse: [ self layoutWhenThereIsAProfiler ]
]

{ #category : #'accessing - lazy presenters' }
IllimaniAllocationProfilerUI >> heatMapPresenter [

	heatmapPresenter ifNil: [ self initializeHeatmapPresenter ].
	^ heatmapPresenter
]

{ #category : #'initialization - lazy presenters' }
IllimaniAllocationProfilerUI >> initializeAllocatedObjectsPerSecond [

	allocatedObjectsPerSecondPresenter := SpRoassalPresenter new
		canvas: (AllocationVisualizations new
			model: objectAllocationProfiler;
			topCalculationsNumber: topCalculationsNumber;
			allocatedObjectsPerSecondLineChartCanvas);
		yourself
]

{ #category : #'initialization - lazy presenters' }
IllimaniAllocationProfilerUI >> initializeAllocatedObjectsPerSecondPerClass [

	allocatedObjectsPerSecondPerClass := SpRoassalPresenter new
		canvas: (AllocationVisualizations new
			model: objectAllocationProfiler;
			topCalculationsNumber: topCalculationsNumber;
			allocatedObjectsPerSecondPerClassLineChartCanvas);
		yourself
]

{ #category : #'initialization - lazy presenters' }
IllimaniAllocationProfilerUI >> initializeCodeEvaluator [

	codeEvaluator := self newCode
		text: 'self objectAllocations';
		beForObject: objectAllocationProfiler;
		yourself
]

{ #category : #'initialization - lazy presenters' }
IllimaniAllocationProfilerUI >> initializeHeatmapPresenter [

	heatmapPresenter := SpRoassalPresenter new
		canvas: (AllocationVisualizations new
			model: objectAllocationProfiler;
			topCalculationsNumber: topCalculationsNumber;
			heatmapAllocatorAllocatedCanvas);
		yourself
]

{ #category : #'initialization - lazy presenters' }
IllimaniAllocationProfilerUI >> initializeNotebook [

	notebookPresenter := self newNotebook
		addPageTitle: 'Summary' provider: [ self summaryAndEvaluatorPresenter ];
		addPageTitle: 'Heatmap' provider: [ self heatMapPresenter ];
			addPageTitle: 'Allocations per Second per Class'
		provider: [ self allocatedObjectsPerSecondPerClass ];
		addPageTitle: 'Allocations per Second'
		provider: [ self allocatedObjectsPerSecondPresenter ];
		addPageTitle: 'Top Allocators' provider: [self topAllocatorsPresenter ];

		addPageTitle: 'Evaluator' provider: [ self codeEvaluator ];
		yourself
]

{ #category : #initialization }
IllimaniAllocationProfilerUI >> initializePresenters [

	topCalculationsNumber := 10.
	self initializeToolbar.
	self initializeTopCalculationsPresenter.
	self respondToAnnouncement
]

{ #category : #'initialization - lazy presenters' }
IllimaniAllocationProfilerUI >> initializeSummaryAndEvaluatorPresenter [

	| statsAndEvaluatorLayout statsPresenter |
	statsPresenter := AllocationSummaryPresenter on: objectAllocationProfiler.

	statsAndEvaluatorLayout := SpPanedLayout newTopToBottom
		positionOfSlider: 0.7;
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

{ #category : #'initialization - lazy presenters' }
IllimaniAllocationProfilerUI >> initializeTopAllocatorsPresenter [

	topAllocatorsPresenter := self newPresenter
		layout: (SpBoxLayout newLeftToRight
			spacing: 5;
			add: self topAllocatorClassesPresenter;
			add: self topAllocatorMethodsPresenter;
			yourself);
		yourself
]

{ #category : #initialization }
IllimaniAllocationProfilerUI >> initializeTopCalculationsPresenter [

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
	(objectAllocationProfiler isProfilingStarted and: [
		 objectAllocationProfiler isProfilingFinished not ]) ifTrue: [
		layoutToReturn := self layoutWhenThereIsNotDataWithMessage: 'Still profiling' ].

	(objectAllocationProfiler isProfilingFinished and: [
		 objectAllocationProfiler objectAllocations isEmpty ]) ifTrue: [
		layoutToReturn := self layoutWhenThereIsNotDataWithMessage: 'Profiling finished without any allocations. No allocations were produced during this profiling' ].

	(objectAllocationProfiler isProfilingFinished and: [
		 objectAllocationProfiler objectAllocations isNotEmpty ]) ifTrue: [
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
IllimaniAllocationProfilerUI >> notebookPresenter [

	notebookPresenter ifNil: [ self initializeNotebook ].
	^ notebookPresenter
]

{ #category : #accessing }
IllimaniAllocationProfilerUI >> objectAllocationProfiler: aProfiler [

	objectAllocationProfiler := aProfiler
]

{ #category : #actions }
IllimaniAllocationProfilerUI >> refresh [

	notebookPresenter := allocatedObjectsPerSecondPresenter := allocatedObjectsPerSecondPerClass := codeEvaluator := summaryAndEvaluatorPresenter := topClassesPresenter := topMethodsPresenter := heatmapPresenter := nil.

	^ self layout: self defaultLayout
]

{ #category : #announcements }
IllimaniAllocationProfilerUI >> respondToAnnouncement [

	 IllimaniAnnouncer uniqueInstance when: IllimaniStopedProfilingAnnouncement do: [ self refresh ]
]

{ #category : #'accessing - lazy presenters' }
IllimaniAllocationProfilerUI >> summaryAndEvaluatorPresenter [

	summaryAndEvaluatorPresenter ifNil: [ self initializeSummaryAndEvaluatorPresenter ].
	^ summaryAndEvaluatorPresenter
]

{ #category : #'accessing - presenters' }
IllimaniAllocationProfilerUI >> topAllocatorClassesPresenter [

	^ SpRoassalPresenter new
		canvas: (AllocationVisualizations new
			model: objectAllocationProfiler;
			topCalculationsNumber: topCalculationsNumber;
			topAllocatorClassesBarChartCanvas);
		yourself
]

{ #category : #'accessing - presenters' }
IllimaniAllocationProfilerUI >> topAllocatorMethodsPresenter [

	^ SpRoassalPresenter new
		canvas: (AllocationVisualizations new
			model: objectAllocationProfiler;
			topCalculationsNumber: topCalculationsNumber;
			topAllocatorMethodsBarChartCanvas);
		yourself
]

{ #category : #'accessing - lazy presenters' }
IllimaniAllocationProfilerUI >> topAllocatorsPresenter [

	topAllocatorsPresenter ifNil: [ self initializeTopAllocatorsPresenter ].
	^ topAllocatorsPresenter
]
