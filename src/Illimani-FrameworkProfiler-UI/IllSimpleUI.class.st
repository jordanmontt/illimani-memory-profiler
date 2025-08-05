Class {
	#name : 'IllSimpleUI',
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
IllSimpleUI class >> profiler: aProfiler announcer: anIllimaniAnnouncer [

	^ self basicNew
		profiler: aProfiler;
		illimaniAnnouncer: anIllimaniAnnouncer;
		initialize;
		yourself
]

{ #category : 'accessing - lazy presenters' }
IllSimpleUI >> codeEvaluator [

	codeEvaluator ifNil: [ self initializeCodeEvaluator ].
	^ codeEvaluator
]

{ #category : 'accessing' }
IllSimpleUI >> codeEvaluatorText [

	^ 'self'
]

{ #category : 'initialization' }
IllSimpleUI >> connectPresenters [

	refreshButton action: [ self refresh ]
]

{ #category : 'layout' }
IllSimpleUI >> controlButtonsLayout [

	^ SpBoxLayout newTopToBottom
		  spacing: 5;
		  add: toolbarPresenter expand: false;
		  yourself
]

{ #category : 'layout' }
IllSimpleUI >> defaultLayout [

	(profiler isProfilingStarted and: [ profiler isProfilingFinished not ]) ifTrue: [
		^ self layoutWhenThereIsNotDataWithMessage: 'Still profiling' ].

	profiler isProfilingFinished ifTrue: [ ^ self layoutWhenThereIsData ]
]

{ #category : 'accessing' }
IllSimpleUI >> illimaniAnnouncer: aIllimaniAnnouncer [

	illimaniAnnouncer := aIllimaniAnnouncer
]

{ #category : 'initialization' }
IllSimpleUI >> initialize [

	super initialize.
	self respondToAnnouncement
]

{ #category : 'initialization - lazy presenters' }
IllSimpleUI >> initializeCodeEvaluator [

	codeEvaluator := self newCode
		text: self codeEvaluatorText;
		beForObject: profiler;
		yourself
]

{ #category : 'initialization' }
IllSimpleUI >> initializeNotebook [

	notebookPresenter := self newNotebook
		addPageTitle: 'Summary' provider: [ self summaryAndEvaluatorPresenter ];
		addPageTitle: 'Evaluator' provider: [ self codeEvaluator ];
		yourself
]

{ #category : 'initialization' }
IllSimpleUI >> initializePresenters [

	self initializeToolbar.
	self initializeNotebook
]

{ #category : 'initialization - lazy presenters' }
IllSimpleUI >> initializeSummaryAndEvaluatorPresenter [

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
IllSimpleUI >> initializeToolbar [

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
IllSimpleUI >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	
	aWindowPresenter
		title: self title;
		initialExtent: 850 @ 760
]

{ #category : 'layout' }
IllSimpleUI >> layoutWhenThereIsData [

	^ SpBoxLayout newTopToBottom
		add: self controlButtonsLayout expand: false;
		add: notebookPresenter;
		yourself
]

{ #category : 'layout' }
IllSimpleUI >> layoutWhenThereIsNotDataWithMessage: aString [

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
IllSimpleUI >> profiler: aProfiler [

	profiler := aProfiler
]

{ #category : 'initialization - lazy presenters' }
IllSimpleUI >> profilerSummaryPresenter [

	^ IllProfilingSummaryPresenter on: profiler
]

{ #category : 'actions' }
IllSimpleUI >> refresh [

	self subclassResponsibility
]

{ #category : 'actions' }
IllSimpleUI >> respondToAnnouncement [

	illimaniAnnouncer when: IllStopedProfilingAnnouncement
		do: [ self refresh ]
		for: self
]

{ #category : 'accessing - lazy presenters' }
IllSimpleUI >> summaryAndEvaluatorPresenter [

	summaryAndEvaluatorPresenter ifNil: [ self initializeSummaryAndEvaluatorPresenter ].
	^ summaryAndEvaluatorPresenter
]

{ #category : 'initialization' }
IllSimpleUI >> title [

	^ 'Illimani Memory Profiler'
]
