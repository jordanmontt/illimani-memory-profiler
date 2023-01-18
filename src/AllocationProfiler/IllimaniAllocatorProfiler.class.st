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
		'toolbarPresenter'
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

	startButton action: [ objectAllocationProfiler startProfiling.
		self toggleStartStopButtons ].
	stopButton action: [ objectAllocationProfiler stopProfiling.
		self toggleStartStopButtons ].

	refreshButton action: [ self layout: self defaultLayout ]
]

{ #category : #layout }
IllimaniAllocatorProfiler >> controlButtonsLayout [

	^ SpBoxLayout newLeftToRight
		  add: toolbarPresenter;
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

	super initialize.
	objectAllocationProfiler := ObjectAllocationProfiler new.
	isItProfiling := false
]

{ #category : #initialization }
IllimaniAllocatorProfiler >> initializeAllocatedObjectsPerSecond [

	^ SpRoassalPresenter new
		canvas: (AllocationVisualizations new
			statsModel: objectAllocationProfiler stats;
			allocatedObjectsPerSecondLineChartCanvas);
		yourself
]

{ #category : #initialization }
IllimaniAllocatorProfiler >> initializeAllocatedObjectsPerSecondPerClass [

	^ SpRoassalPresenter new
		canvas: (AllocationVisualizations new
			statsModel: objectAllocationProfiler stats;
			allocatedObjectsPerSecondPerClassLineChartCanvas);
		yourself
]

{ #category : #initialization }
IllimaniAllocatorProfiler >> initializeGeneralStats [

	^ ObjectAllocationStatsPresenter on: objectAllocationProfiler stats
]

{ #category : #initialization }
IllimaniAllocatorProfiler >> initializePresenters [

	notebookPresenter := self newNotebook.
	notebookPresenter
		addPageTitle: 'General Stats' provider: [ self initializeGeneralStats ];
		addPageTitle: 'Allocated Objects per Second'
		provider: [ self initializeAllocatedObjectsPerSecond ];
		addPageTitle: 'Allocated Objects per Second per Class'
		provider: [ self initializeAllocatedObjectsPerSecondPerClass ];
		addPageTitle: 'Top Allocator Classes' provider: [ self initializeTopClassesPresenter ];
		addPageTitle: 'Top Allocator Methods' provider: [ self initializeTopMethodsPresenter ].

	self initializeToolbar
]

{ #category : #initialization }
IllimaniAllocatorProfiler >> initializeToolbar [

	startButton := self newToolbarButton
		               label: 'Start Profiling';
		               icon: (self iconNamed: #smallProfile);
		               action: [
			               objectAllocationProfiler startProfiling.
			               self toggleStartStopButtons ];
		               yourself.
	stopButton := self newToolbarButton
		              label: 'Stop Profiling';
		              icon: (self iconNamed: #smallCancel);
		              action: [
			              objectAllocationProfiler stopProfiling.
			              self toggleStartStopButtons ];
		              yourself.
	refreshButton := self newToolbarButton
		                 label: 'Refresh';
		                 icon: (self iconNamed: #smallUpdate);
		                 action: [ self layout: self defaultLayout ];
		                 yourself.
	toolbarPresenter := self newToolbar
		                    beBoth;
		                    addItemLeft: startButton;
		                    addItemLeft: stopButton;
		                    addItemLeft: refreshButton;
		                    yourself
]

{ #category : #initialization }
IllimaniAllocatorProfiler >> initializeTopClassesPresenter [

	^ SpRoassalPresenter new
		canvas: (AllocationVisualizations new
			statsModel: objectAllocationProfiler stats;
			topClassesThatAllocateObjectsBarChartCanvas);
		yourself
]

{ #category : #initialization }
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
