Class {
	#name : 'IllAbstractUI',
	#superclass : 'SpPresenter',
	#instVars : [
		'notebookPresenter',
		'refreshButton',
		'toolbarPresenter',
		'profiler',
		'illimaniAnnouncer',
		'codeEvaluator',
		'summaryAndEvaluatorPresenter'
	],
	#category : 'Illimani-FrameworkProfiler-UI-Main Presenter',
	#package : 'Illimani-FrameworkProfiler-UI',
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

	refreshButton action: [ self refresh ]
]

{ #category : 'layout' }
IllAbstractUI >> controlButtonsLayout [

	^ SpBoxLayout newTopToBottom
		  spacing: 5;
		  add: toolbarPresenter expand: false;
		  yourself
]

{ #category : 'layout' }
IllAbstractUI >> defaultLayout [

	(profiler isProfilingStarted and: [ profiler isProfilingFinished not ]) ifTrue: [
		^ self layoutWhenThereIsNotDataWithMessage: 'Still profiling' ].

	(profiler isProfilingFinished and: [ profiler objectAllocations isEmpty ]) ifTrue: [
		^ self layoutWhenThereIsNotDataWithMessage: 'Profiling finished without any allocations. No allocations were produced during this profiling' ].

	(profiler isProfilingFinished and: [ profiler objectAllocations isNotEmpty ]) ifTrue: [
		^ self layoutWhenThereIsData ]
]

{ #category : 'accessing' }
IllAbstractUI >> illimaniAnnouncer: aIllimaniAnnouncer [

	illimaniAnnouncer := aIllimaniAnnouncer
]

{ #category : 'initialization' }
IllAbstractUI >> initialize [

	super initialize.
	self respondToAnnouncement
]

{ #category : 'initialization - lazy presenters' }
IllAbstractUI >> initializeCodeEvaluator [

	codeEvaluator := self newCode
		text: self codeEvaluatorText;
		beForObject: profiler;
		yourself
]

{ #category : 'initialization' }
IllAbstractUI >> initializeNotebook [

	notebookPresenter := self newNotebook
		addPageTitle: 'Summary' provider: [ self summaryAndEvaluatorPresenter ];
		addPageTitle: 'Evaluator' provider: [ self codeEvaluator ];
		yourself
]

{ #category : 'initialization' }
IllAbstractUI >> initializePresenters [

	self initializeToolbar.
	self initializeNotebook
]

{ #category : 'initialization - lazy presenters' }
IllAbstractUI >> initializeSummaryAndEvaluatorPresenter [

	| statsAndEvaluatorLayout statsPresenter |
	statsPresenter :=	self profilerSummaryPresenter.

	statsAndEvaluatorLayout := SpPanedLayout newTopToBottom
		positionOfSlider: 0.8;
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
IllAbstractUI >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: self title;
		initialExtent: 850 @ 760;
		whenResizingDo: [ :ann |
				aWindowPresenter isResizable ifTrue: [
						self preferredExtent: ann newSize ] ]
]

{ #category : 'layout' }
IllAbstractUI >> layoutWhenThereIsData [

	^ SpBoxLayout newTopToBottom
		add: self controlButtonsLayout expand: false;
		add: notebookPresenter;
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

{ #category : 'accessing' }
IllAbstractUI >> profiler: aProfiler [

	profiler := aProfiler
]

{ #category : 'initialization - lazy presenters' }
IllAbstractUI >> profilerSummaryPresenter [

	^ IllProfilingSummaryPresenter on: profiler
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

{ #category : 'initialization' }
IllAbstractUI >> title [

	^ 'Illimani Memory Profiler'
]
