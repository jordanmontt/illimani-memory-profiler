Class {
	#name : #IllimaniAllocatorProfiler,
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
	#category : #AllocationProfiler
}

{ #category : #'instance creation' }
IllimaniAllocatorProfiler class >> open [

	<script>
	^ self new open
]

{ #category : #initialization }
IllimaniAllocatorProfiler >> connectPresenters [

	startButton action: [
		objectAllocationProfiler startProfiling.
		self toggleStartStopButtons ].
	stopButton action: [
		objectAllocationProfiler stopProfiling.
		self toggleStartStopButtons ].
	refreshButton action: [ self layout: self defaultLayout ].
	profilerHandlerDropListPresenter whenSelectedItemChangedDo: [ :aClass | objectAllocationProfiler profilerHandler: aClass new ]
]

{ #category : #layout }
IllimaniAllocatorProfiler >> controlButtonsLayout [

	^ SpBoxLayout newTopToBottom
		  spacing: 5;
		  add: toolbarPresenter;
		  add: (SpBoxLayout newLeftToRight
				   vAlignCenter;
				   add: 'Profile the allocation of: ' expand: false;
				   add: profilerHandlerDropListPresenter;
				   yourself);
		  yourself
]

{ #category : #layout }
IllimaniAllocatorProfiler >> defaultLayout [

	^ objectAllocationProfiler objectAllocations
		ifEmpty: [ self layoutWhenThereIsNotData ]
		ifNotEmpty: [ self layoutWhenThereIsData ]
]

{ #category : #initialization }
IllimaniAllocatorProfiler >> initialize [

	objectAllocationProfiler := ObjectAllocationProfiler new.
	isItProfiling := false.
	super initialize
]

{ #category : #'initialization - custom presenters' }
IllimaniAllocatorProfiler >> initializeAllocatedObjectsPerSecond [

	^ SpRoassalPresenter new
		canvas: (AllocationVisualizations new
			statsModel: objectAllocationProfiler stats;
			allocatedObjectsPerSecondLineChartCanvas);
		yourself
]

{ #category : #'initialization - custom presenters' }
IllimaniAllocatorProfiler >> initializeAllocatedObjectsPerSecondPerClass [

	^ SpRoassalPresenter new
		canvas: (AllocationVisualizations new
			statsModel: objectAllocationProfiler stats;
			allocatedObjectsPerSecondPerClassLineChartCanvas);
		yourself
]

{ #category : #'initialization - custom presenters' }
IllimaniAllocatorProfiler >> initializeGeneralStats [

	^ ObjectAllocationStatsPresenter on: objectAllocationProfiler stats
]

{ #category : #'initialization - custom presenters' }
IllimaniAllocatorProfiler >> initializeNotebook [

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
IllimaniAllocatorProfiler >> initializePresenters [

	self initializeNotebook.
	self initializeToolbar.
	self initializeProxyHandlerDropList
]

{ #category : #'initialization - custom presenters' }
IllimaniAllocatorProfiler >> initializeProxyHandlerDropList [

	profilerHandlerDropListPresenter := self newDropList
		items: (MpObjectAllocationProfilerHandler allSubclasses sorted: [ :a :b | a prettyName < b prettyName ]);
		display: [ :aClass | aClass prettyName ];
		selectItem: objectAllocationProfiler class
		defaultProfilerHandlerClass;
		yourself
]

{ #category : #'initialization - custom presenters' }
IllimaniAllocatorProfiler >> initializeToolbar [

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
		                 label: 'Refresh';
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
IllimaniAllocatorProfiler >> initializeTopClassesPresenter [

	^ SpRoassalPresenter new
		canvas: (AllocationVisualizations new
			statsModel: objectAllocationProfiler stats;
			topClassesThatAllocateObjectsBarChartCanvas);
		yourself
]

{ #category : #'initialization - custom presenters' }
IllimaniAllocatorProfiler >> initializeTopMethodsPresenter [

	^ SpRoassalPresenter new
		canvas: (AllocationVisualizations new
			statsModel: objectAllocationProfiler stats;
			topMethodsThatAllocateObjectsBarChartCanvas);
		yourself
]

{ #category : #initialization }
IllimaniAllocatorProfiler >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Illimani: a Memory Profiler';
		initialExtent: 1000 @ 650
]

{ #category : #layout }
IllimaniAllocatorProfiler >> layoutWhenThereIsData [

	^ SpBoxLayout newTopToBottom
		  add: self controlButtonsLayout expand: false;
		  add: notebookPresenter;
		  yourself
]

{ #category : #layout }
IllimaniAllocatorProfiler >> layoutWhenThereIsNotData [

	^ SpBoxLayout newTopToBottom
		  add: self controlButtonsLayout expand: false;
		  add: (SpBoxLayout newTopToBottom
				   vAlignCenter;
				   hAlignCenter;
				   add: 'No data to show. Start profiling!';
				   yourself);
		  yourself
]

{ #category : #actions }
IllimaniAllocatorProfiler >> toggleStartStopButtons [

	isItProfiling := isItProfiling not.
	startButton enabled: isItProfiling not.
	stopButton enabled: isItProfiling
]
