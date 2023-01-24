Class {
	#name : #IllimaniAllocationProfilerUI,
	#superclass : #SpPresenter,
	#instVars : [
		'notebookPresenter',
		'objectAllocationProfiler',
		'refreshButton',
		'toolbarPresenter'
	],
	#category : #'AllocationProfiler-UI'
}

{ #category : #initialization }
IllimaniAllocationProfilerUI >> connectPresenters [

	refreshButton action: [ self layout: self defaultLayout ]
]

{ #category : #layout }
IllimaniAllocationProfilerUI >> controlButtonsLayout [

	^ SpBoxLayout newTopToBottom
		  spacing: 5;
		  add: toolbarPresenter;
		  yourself
]

{ #category : #layout }
IllimaniAllocationProfilerUI >> defaultLayout [

	objectAllocationProfiler ifNil: [
		^ self layoutWhenThereIsNotDataWithMessage: 'No Profiler backend set.' ].
	^ objectAllocationProfiler objectAllocations
		ifEmpty: [ self layoutWhenThereIsNotDataWithMessage: 'No data to display.' ]
		ifNotEmpty: [ self layoutWhenThereIsData ]
]

{ #category : #initialization }
IllimaniAllocationProfilerUI >> initialize [

	objectAllocationProfiler := IllimaniAllocationProfiler new.
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

	^ (AllocationStatisticsPresenter on: objectAllocationProfiler stats)
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
	self initializeToolbar
]

{ #category : #'initialization - custom presenters' }
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

{ #category : #accessing }
IllimaniAllocationProfilerUI >> objectAllocationProfiler: aProfiler [

	objectAllocationProfiler := aProfiler
]
