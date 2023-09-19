Class {
	#name : 'IllimaniFinalizationProfilerUI',
	#superclass : 'IllimaniAbstractUI',
	#traits : 'IllimaniTInformationPresenters',
	#classTraits : 'IllimaniTInformationPresenters classTrait',
	#category : 'IllimaniAllocationProfiler-UI-Main Presenter',
	#package : 'IllimaniAllocationProfiler-UI',
	#tag : 'Main Presenter'
}

{ #category : 'initialization - lazy presenters' }
IllimaniFinalizationProfilerUI >> initializeNotebook [

	notebookPresenter := self newNotebook
		addPageTitle: 'Summary' provider: [ self summaryAndEvaluatorPresenter ];
		addPageTitle: 'Memory' provider: [ self memoryTablePresenter  ];
		addPageTitle: 'Allocated Objects' provider: [ self allocatedObjectsTablePresenter ];

		addPageTitle: 'Evaluator' provider: [ self codeEvaluator ];
		yourself
]

{ #category : 'actions' }
IllimaniFinalizationProfilerUI >> refresh [

	self layout: self defaultLayout
]
