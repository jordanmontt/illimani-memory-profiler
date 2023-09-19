Trait {
	#name : 'IllimaniTInformationPresenters',
	#instVars : [
		'codeEvaluator',
		'profiler'
	],
	#category : 'IllimaniAllocationProfiler-UI-Main Presenter',
	#package : 'IllimaniAllocationProfiler-UI',
	#tag : 'Main Presenter'
}

{ #category : 'initialization - lazy presenters' }
IllimaniTInformationPresenters >> initializeCodeEvaluator [

	codeEvaluator := self newCode
		text: 'self objectAllocations.
self stats allocationsByClass.
self stats allocationsByMethod';
		beForObject: profiler;
		yourself
]

{ #category : 'initialization - lazy presenters' }
IllimaniTInformationPresenters >> initializeMemoryTablePresenter [

	memoryTablePresenter := AlternatorPresenter new
		presenterOne: (TableMemoryInformationPresenter owner: self on: profiler stats allocationsByClass)
		withName: 'Classes';
		presenterTwo: (TableMemoryInformationPresenter owner: self on: profiler stats allocationsByMethod)
		withName: 'Methods';
		yourself
]

{ #category : 'initialization - lazy presenters' }
IllimaniTInformationPresenters >> initializeSummaryAndEvaluatorPresenter [

	| statsAndEvaluatorLayout statsPresenter |
	statsPresenter := AllocationSummaryPresenter on: profiler.

	statsAndEvaluatorLayout := SpPanedLayout newTopToBottom
		positionOfSlider: 0.75;
		add: statsPresenter;
		add: self codeEvaluator;
		yourself.

	summaryAndEvaluatorPresenter := SpPresenter new
		layout: statsAndEvaluatorLayout ;
		yourself
]
