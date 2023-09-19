Trait {
	#name : 'IllimaniTInformationPresenters',
	#instVars : [
		'codeEvaluator',
		'summaryAndEvaluatorPresenter',
		'memoryTablePresenter',
		'allocatedObjectsTablePresenter'
	],
	#category : 'IllimaniAllocationProfiler-UI-Main Presenter',
	#package : 'IllimaniAllocationProfiler-UI',
	#tag : 'Main Presenter'
}

{ #category : 'accessing - lazy presenters' }
IllimaniTInformationPresenters >> allocatedObjectsTablePresenter [

	allocatedObjectsTablePresenter ifNil: [ self initializeAllocatedObjectsTablePresenter ].
	^ allocatedObjectsTablePresenter
]

{ #category : 'accessing - lazy presenters' }
IllimaniTInformationPresenters >> codeEvaluator [

	codeEvaluator ifNil: [ self initializeCodeEvaluator ].
	^ codeEvaluator
]

{ #category : 'initialization - lazy presenters' }
IllimaniTInformationPresenters >> initializeAllocatedObjectsTablePresenter [

	allocatedObjectsTablePresenter := self instantiate: (AllocatedObjectsTablePresenter on: self profiler objectAllocations)
]

{ #category : 'initialization - lazy presenters' }
IllimaniTInformationPresenters >> initializeCodeEvaluator [

	codeEvaluator := self newCode
		text: 'self objectAllocations.
self stats allocationsByClass.
self stats allocationsByMethod';
		beForObject: self profiler;
		yourself
]

{ #category : 'initialization - lazy presenters' }
IllimaniTInformationPresenters >> initializeMemoryTablePresenter [

	memoryTablePresenter := AlternatorPresenter new
		presenterOne: (TableMemoryInformationPresenter owner: self on: self profiler stats allocationsByClass)
		withName: 'Classes';
		presenterTwo: (TableMemoryInformationPresenter owner: self on: self profiler stats allocationsByMethod)
		withName: 'Methods';
		yourself
]

{ #category : 'initialization - lazy presenters' }
IllimaniTInformationPresenters >> initializeSummaryAndEvaluatorPresenter [

	| statsAndEvaluatorLayout statsPresenter |
	statsPresenter := AllocationSummaryPresenter on: self profiler.

	statsAndEvaluatorLayout := SpPanedLayout newTopToBottom
		positionOfSlider: 0.75;
		add: statsPresenter;
		add: self codeEvaluator;
		yourself.

	summaryAndEvaluatorPresenter := SpPresenter new
		layout: statsAndEvaluatorLayout ;
		yourself
]

{ #category : 'accessing - lazy presenters' }
IllimaniTInformationPresenters >> memoryTablePresenter [

	memoryTablePresenter ifNil: [ self initializeMemoryTablePresenter ].
	^ memoryTablePresenter
]

{ #category : 'accessing - lazy presenters' }
IllimaniTInformationPresenters >> summaryAndEvaluatorPresenter [

	summaryAndEvaluatorPresenter ifNil: [ self initializeSummaryAndEvaluatorPresenter ].
	^ summaryAndEvaluatorPresenter
]
