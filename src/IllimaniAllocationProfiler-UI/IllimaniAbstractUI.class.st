Class {
	#name : 'IllimaniAbstractUI',
	#superclass : 'SpPresenter',
	#instVars : [
		'notebookPresenter',
		'refreshButton',
		'toolbarPresenter',
		'profiler',
		'illimaniAnnouncer',
		'topCalculationsNumberInputPresenter',
		'topCalculationsNumber'
	],
	#category : 'IllimaniAllocationProfiler-UI-Main Presenter',
	#package : 'IllimaniAllocationProfiler-UI',
	#tag : 'Main Presenter'
}

{ #category : 'accessing' }
IllimaniAbstractUI class >> profiler: aProfiler announcer: anIllimaniAnnouncer [

	^ self basicNew
		profiler: aProfiler;
		illimaniAnnouncer: anIllimaniAnnouncer;
		initialize;
		yourself
]

{ #category : 'initialization' }
IllimaniAbstractUI >> connectPresenters [

	refreshButton action: [ self refresh ].
	topCalculationsNumberInputPresenter whenNumberChangedDo: [ :newValue | topCalculationsNumber := newValue ]
]

{ #category : 'layout' }
IllimaniAbstractUI >> controlButtonsLayout [

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
IllimaniAbstractUI >> defaultLayout [

	^ (profiler isNil or: [ profiler isProfilingStarted not ])
		  ifTrue: [ self layoutWhenThereIsNotDataWithMessage: 'Profiler backend not set or not it didn''t start to profile.' ]
		  ifFalse: [ self layoutWhenThereIsAProfiler ]
]

{ #category : 'accessing' }
IllimaniAbstractUI >> illimaniAnnouncer: aIllimaniAnnouncer [

	illimaniAnnouncer := aIllimaniAnnouncer
]

{ #category : 'initialization - lazy presenters' }
IllimaniAbstractUI >> initializeNotebook [

	self subclassResponsibility
]

{ #category : 'initialization' }
IllimaniAbstractUI >> initializePresenters [

	self initializeToolbar.
	self respondToAnnouncement.
	topCalculationsNumber := 10.
	self initializeTopCalculationsInputPresenter
]

{ #category : 'initialization' }
IllimaniAbstractUI >> initializeToolbar [

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
IllimaniAbstractUI >> initializeTopCalculationsInputPresenter [

	topCalculationsNumberInputPresenter := self newNumberInput
		number: topCalculationsNumber;
		minimum: 1;
		yourself
]

{ #category : 'initialization' }
IllimaniAbstractUI >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Illimani Memory Profiler';
		initialExtent: 1000 @ 650
]

{ #category : 'layout' }
IllimaniAbstractUI >> layoutWhenThereIsAProfiler [

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
IllimaniAbstractUI >> layoutWhenThereIsData [

	^ SpBoxLayout newTopToBottom
		add: self controlButtonsLayout expand: false;
		add: self notebookPresenter;
		yourself
]

{ #category : 'layout' }
IllimaniAbstractUI >> layoutWhenThereIsNotDataWithMessage: aString [

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
IllimaniAbstractUI >> profiler [

	^ profiler
]

{ #category : 'accessing' }
IllimaniAbstractUI >> profiler: aProfiler [

	profiler := aProfiler
]

{ #category : 'actions' }
IllimaniAbstractUI >> refresh [

	self subclassResponsibility
]

{ #category : 'actions' }
IllimaniAbstractUI >> respondToAnnouncement [

	illimaniAnnouncer when: IllimaniStopedProfilingAnnouncement
		do: [ self refresh ]
		for: self
]
