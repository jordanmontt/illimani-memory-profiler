Class {
	#name : #IllimaniAllocationProfilerUI,
	#superclass : #SpPresenter,
	#instVars : [
		'notebookPresenter',
		'objectAllocationProfiler',
		'startButton',
		'stopButton',
		'isItProfiling',
		'refreshButton',
		'toolbarPresenter',
		'profilerHandlerDropListPresenter'
	],
	#category : #'AllocationProfiler-UI'
}

{ #category : #'instance creation' }
IllimaniAllocationProfilerUI class >> open [

	<script>
	^ self new open
]

{ #category : #initialization }
IllimaniAllocationProfilerUI >> connectPresenters [

	startButton action: [
		objectAllocationProfiler startProfiling.
		self toggleStartStopButtons ].
	stopButton action: [
		objectAllocationProfiler stopProfiling.
		self toggleStartStopButtons ].
	refreshButton action: [ self layout: self defaultLayout ].

	profilerHandlerDropListPresenter whenSelectedItemChangedDo: [ :aClass |
		objectAllocationProfiler profilerHandler: aClass new ]
]

{ #category : #layout }
IllimaniAllocationProfilerUI >> controlButtonsLayout [

	^ SpBoxLayout newTopToBottom
		  spacing: 5;
		  add: toolbarPresenter;
		  add: (SpBoxLayout newLeftToRight
				   vAlignCenter;
				   spacing: 5;
				   add: 'Profile the allocation of: ' expand: false;
				   add: profilerHandlerDropListPresenter;
				   yourself);
		  yourself
]

{ #category : #layout }
IllimaniAllocationProfilerUI >> defaultLayout [

	^ objectAllocationProfiler objectAllocations
		ifEmpty: [ self layoutWhenThereIsNotData ]
		ifNotEmpty: [ self layoutWhenThereIsData ]
]

{ #category : #initialization }
IllimaniAllocationProfilerUI >> initialize [

	objectAllocationProfiler := IllimaniAllocationProfiler new.
	isItProfiling := false.
	super initialize
]

{ #category : #'initialization - custom presenters' }
IllimaniAllocationProfilerUI >> initializeAllocatedObjectsPerSecond [

	^ SpRoassalPresenter new
		canvas: (AllocationVisualizations new
			statsModel: objectAllocationProfiler stats;
			allocatedObjectsPerSecondLineChartCanvas);
		yourself
]

{ #category : #'initialization - custom presenters' }
IllimaniAllocationProfilerUI >> initializeAllocatedObjectsPerSecondPerClass [

	^ SpRoassalPresenter new
		canvas: (AllocationVisualizations new
			statsModel: objectAllocationProfiler stats;
			allocatedObjectsPerSecondPerClassLineChartCanvas);
		yourself
]

{ #category : #'initialization - custom presenters' }
IllimaniAllocationProfilerUI >> initializeGeneralStats [

	^ (ObjectAllocationStatsPresenter on: objectAllocationProfiler stats)
		  beEvaluatorForObject: objectAllocationProfiler;
		  totalProfiledTimeBlock: [ objectAllocationProfiler totalProfiledTime ];
		  yourself
]

{ #category : #'initialization - custom presenters' }
IllimaniAllocationProfilerUI >> initializeNotebook [

	notebookPresenter := self newNotebook.
	notebookPresenter
		addPageTitle: 'General Stats' provider: [ self initializeGeneralStats ];
		addPageTitle: 'Allocated Objects per Second'
		provider: [ self initializeAllocatedObjectsPerSecond ];
		addPageTitle: 'Allocated Objects per Second per Class'
		provider: [ self initializeAllocatedObjectsPerSecondPerClass ];
		addPageTitle: 'Top Allocator Classes' provider: [ self initializeTopClassesPresenter ];
		addPageTitle: 'Top Allocator Methods' provider: [ self initializeTopMethodsPresenter ]
]

{ #category : #initialization }
IllimaniAllocationProfilerUI >> initializePresenters [

	self initializeNotebook.
	self initializeToolbar.
	self initializeProxyHandlerDropList
]

{ #category : #'initialization - custom presenters' }
IllimaniAllocationProfilerUI >> initializeProxyHandlerDropList [

	profilerHandlerDropListPresenter := self newDropList
		items: (MpObjectAllocationProfilerHandler allSubclasses sorted: [ :a :b | a prettyName < b prettyName ]);
		display: [ :aClass | aClass prettyName ];
		selectItem: objectAllocationProfiler class defaultProfilerHandlerClass;
		yourself
]

{ #category : #'initialization - custom presenters' }
IllimaniAllocationProfilerUI >> initializeToolbar [

	startButton := self newToolbarButton
		               label: 'Start Profiling';
		               icon: (self iconNamed: #smallProfile);
		               yourself.
	stopButton := self newToolbarButton
		              label: 'Stop Profiling';
		              icon: (self iconNamed: #smallCancel);
		              disable;
		              yourself.
	refreshButton := self newToolbarButton
		                 label: 'Refresh views';
		                 icon: (self iconNamed: #smallUpdate);
		                 yourself.
	toolbarPresenter := self newToolbar
		                    beBoth;
		                    addItemLeft: startButton;
		                    addItemLeft: stopButton;
		                    addItemLeft: refreshButton;
		                    yourself
]

{ #category : #'initialization - custom presenters' }
IllimaniAllocationProfilerUI >> initializeTopClassesPresenter [

	^ SpRoassalPresenter new
		canvas: (AllocationVisualizations new
			statsModel: objectAllocationProfiler stats;
			topClassesThatAllocateObjectsBarChartCanvas);
		yourself
]

{ #category : #'initialization - custom presenters' }
IllimaniAllocationProfilerUI >> initializeTopMethodsPresenter [

	^ SpRoassalPresenter new
		canvas: (AllocationVisualizations new
			statsModel: objectAllocationProfiler stats;
			topMethodsThatAllocateObjectsBarChartCanvas);
		yourself
]

{ #category : #initialization }
IllimaniAllocationProfilerUI >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Illimani Memory Profiler';
		initialExtent: 1000 @ 650
]

{ #category : #layout }
IllimaniAllocationProfilerUI >> layoutWhenThereIsData [

	^ SpBoxLayout newTopToBottom
		  add: self controlButtonsLayout expand: false;
		  add: notebookPresenter;
		  yourself
]

{ #category : #layout }
IllimaniAllocationProfilerUI >> layoutWhenThereIsNotData [

	^ SpBoxLayout newTopToBottom
		  add: self controlButtonsLayout expand: false;
		  add: (SpBoxLayout newTopToBottom
				   vAlignCenter;
				   hAlignCenter;
				   add: 'No data to display.';
				   yourself);
		  yourself
]

{ #category : #accessing }
IllimaniAllocationProfilerUI >> objectAllocationProfiler: aProfiler [

	objectAllocationProfiler := aProfiler
]

{ #category : #actions }
IllimaniAllocationProfilerUI >> toggleStartStopButtons [

	isItProfiling := isItProfiling not.
	startButton enabled: isItProfiling not.
	stopButton enabled: isItProfiling
]
