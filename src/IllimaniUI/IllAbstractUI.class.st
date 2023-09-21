Class {
	#name : 'IllAbstractUI',
	#superclass : 'SpPresenter',
	#instVars : [
		'notebookPresenter',
		'refreshButton',
		'toolbarPresenter',
		'profiler',
		'illimaniAnnouncer',
		'topCalculationsNumberInputPresenter',
		'topCalculationsNumber',
		'codeEvaluator',
		'allocatedObjectsTablePresenter',
		'summaryAndEvaluatorPresenter'
	],
	#category : 'IllimaniUI-Main Presenter',
	#package : 'IllimaniUI',
	#tag : 'Main Presenter'
}

{ #category : 'accessing' }
IllAbstractUI class >> profiler: aProfiler announcer: anIllimaniAnnouncer [

	^ self basicNew
		profiler: aProfiler;
		illimaniAnnouncer: anIllimaniAnnouncer;
		initialize;
		yourself
]

{ #category : 'accessing - lazy presenters' }
IllAbstractUI >> allocatedObjectsTablePresenter [

	allocatedObjectsTablePresenter ifNil: [ self initializeAllocatedObjectsTablePresenter ].
	^ allocatedObjectsTablePresenter
]

{ #category : 'accessing - lazy presenters' }
IllAbstractUI >> codeEvaluator [

	codeEvaluator ifNil: [ self initializeCodeEvaluator ].
	^ codeEvaluator
]

{ #category : 'accessing' }
IllAbstractUI >> codeEvaluatorText [

	^ self subclassResponsibility
]

{ #category : 'initialization' }
IllAbstractUI >> connectPresenters [

	refreshButton action: [ self refresh ].
	topCalculationsNumberInputPresenter whenNumberChangedDo: [ :newValue | topCalculationsNumber := newValue ]
]

{ #category : 'layout' }
IllAbstractUI >> controlButtonsLayout [

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

{ #category : 'layout' }
IllAbstractUI >> defaultLayout [

	^ (profiler isNil or: [ profiler isProfilingStarted not ])
		  ifTrue: [ self layoutWhenThereIsNotDataWithMessage: 'Profiler backend not set or not it didn''t start to profile.' ]
		  ifFalse: [ self layoutWhenThereIsAProfiler ]
]

{ #category : 'accessing' }
IllAbstractUI >> illimaniAnnouncer: aIllimaniAnnouncer [

	illimaniAnnouncer := aIllimaniAnnouncer
]

{ #category : 'initialization - lazy presenters' }
IllAbstractUI >> initializeAllocatedObjectsTablePresenter [

	allocatedObjectsTablePresenter := self instantiate: (AllocatedObjectsTablePresenter on: profiler objectAllocations)
]

{ #category : 'initialization - lazy presenters' }
IllAbstractUI >> initializeCodeEvaluator [

	codeEvaluator := self newCode
		text: self codeEvaluatorText;
		beForObject: profiler;
		yourself
]

{ #category : 'initialization - lazy presenters' }
IllAbstractUI >> initializeNotebook [

	self subclassResponsibility
]

{ #category : 'initialization' }
IllAbstractUI >> initializePresenters [

	self initializeToolbar.
	self respondToAnnouncement.
	topCalculationsNumber := 10.
	self initializeTopCalculationsInputPresenter
]

{ #category : 'initialization - lazy presenters' }
IllAbstractUI >> initializeSummaryAndEvaluatorPresenter [

	| statsAndEvaluatorLayout statsPresenter |
	statsPresenter :=	self summaryStatsPresenter.

	statsAndEvaluatorLayout := SpPanedLayout newTopToBottom
		positionOfSlider: 0.75;
		add: statsPresenter;
		add: self codeEvaluator;
		yourself.

	summaryAndEvaluatorPresenter := SpPresenter new
		layout: statsAndEvaluatorLayout ;
		yourself
]

{ #category : 'initialization' }
IllAbstractUI >> initializeToolbar [

	refreshButton := self newToolbarButton
		label: 'Refresh views';
		icon: (self iconNamed: #smallUpdate);
		yourself.
	toolbarPresenter := self newToolbar
		beBoth;
		addItemLeft: refreshButton;
		yourself
]

{ #category : 'initialization' }
IllAbstractUI >> initializeTopCalculationsInputPresenter [

	topCalculationsNumberInputPresenter := self newNumberInput
		number: topCalculationsNumber;
		minimum: 1;
		yourself
]

{ #category : 'initialization' }
IllAbstractUI >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: self title;
		initialExtent: 1000 @ 650
]

{ #category : 'layout' }
IllAbstractUI >> layoutWhenThereIsAProfiler [

	| layoutToReturn |
	(profiler isProfilingStarted and: [ profiler isProfilingFinished not ]) ifTrue: [
		layoutToReturn := self layoutWhenThereIsNotDataWithMessage: 'Still profiling' ].

	(profiler isProfilingFinished and: [ profiler objectAllocations isEmpty ]) ifTrue: [
		layoutToReturn := self layoutWhenThereIsNotDataWithMessage: 'Profiling finished without any allocations. No allocations were produced during this profiling' ].

	(profiler isProfilingFinished and: [ profiler objectAllocations isNotEmpty ]) ifTrue: [
		layoutToReturn := self layoutWhenThereIsData ].

	^ layoutToReturn
]

{ #category : 'layout' }
IllAbstractUI >> layoutWhenThereIsData [

	^ SpBoxLayout newTopToBottom
		add: self controlButtonsLayout expand: false;
		add: self notebookPresenter;
		yourself
]

{ #category : 'layout' }
IllAbstractUI >> layoutWhenThereIsNotDataWithMessage: aString [

	^ SpBoxLayout newTopToBottom
		  add: self controlButtonsLayout expand: false;
		  add: (SpBoxLayout newTopToBottom
				   vAlignCenter;
				   hAlignCenter;
				   add: aString;
				   yourself);
		  yourself
]

{ #category : 'accessing - lazy presenters' }
IllAbstractUI >> notebookPresenter [

	notebookPresenter ifNil: [ self initializeNotebook ].
	^ notebookPresenter
]

{ #category : 'accessing' }
IllAbstractUI >> profiler: aProfiler [

	profiler := aProfiler
]

{ #category : 'actions' }
IllAbstractUI >> refresh [

	self subclassResponsibility
]

{ #category : 'actions' }
IllAbstractUI >> respondToAnnouncement [

	illimaniAnnouncer when: IllStopedProfilingAnnouncement
		do: [ self refresh ]
		for: self
]

{ #category : 'accessing - lazy presenters' }
IllAbstractUI >> summaryAndEvaluatorPresenter [

	summaryAndEvaluatorPresenter ifNil: [ self initializeSummaryAndEvaluatorPresenter ].
	^ summaryAndEvaluatorPresenter
]

{ #category : 'initialization - lazy presenters' }
IllAbstractUI >> summaryStatsPresenter [

	^ self subclassResponsibility
]

{ #category : 'initialization' }
IllAbstractUI >> title [

	^ 'Illimani Memory Profiler'
]
