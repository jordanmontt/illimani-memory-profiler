Trait {
	#name : 'IllimaniTRoassalPresenters',
	#instVars : [
		'allocatedObjectsPerSecondPresenter',
		'heatmapPresenter',
		'allocationsPerSecondPerAllocatorPresenter'
	],
	#category : 'IllimaniAllocationProfiler-UI-Main Presenter',
	#package : 'IllimaniAllocationProfiler-UI',
	#tag : 'Main Presenter'
}

{ #category : 'accessing - lazy presenters' }
IllimaniTRoassalPresenters >> allocatedObjectsPerSecondPerClassPresenter [

	^ SpRoassalPresenter new
		canvas: (IllimaniRoassalChartBuilder new
			model: self profiler;
			topCalculationsNumber: self topCalculationsNumber;
			allocatedObjectsPerSecondPerClassLineChartCanvas);
		yourself
]

{ #category : 'accessing - lazy presenters' }
IllimaniTRoassalPresenters >> allocatedObjectsPerSecondPerMethodPresenter [

	^ SpRoassalPresenter new
		canvas: (IllimaniRoassalChartBuilder new
			model: self profiler;
			topCalculationsNumber: self topCalculationsNumber;
			allocatedObjectsPerSecondPerMethodLineChartCanvas);
		yourself
]

{ #category : 'accessing - lazy presenters' }
IllimaniTRoassalPresenters >> allocatedObjectsPerSecondPresenter [

	allocatedObjectsPerSecondPresenter ifNil: [ self initializeAllocatedObjectsPerSecond ].
	^ allocatedObjectsPerSecondPresenter
]

{ #category : 'accessing - lazy presenters' }
IllimaniTRoassalPresenters >> allocationsPerSecondPerAllocatorPresenter [

	allocationsPerSecondPerAllocatorPresenter ifNil: [ self initializeAllocationsPerSecondPerAllocator ].
	^ allocationsPerSecondPerAllocatorPresenter
]

{ #category : 'accessing - lazy presenters' }
IllimaniTRoassalPresenters >> heatMapPresenter [

	heatmapPresenter ifNil: [ self initializeHeatmapPresenter ].
	^ heatmapPresenter
]

{ #category : 'initialization - lazy presenters' }
IllimaniTRoassalPresenters >> initializeAllocatedObjectsPerSecond [

	allocatedObjectsPerSecondPresenter := SpRoassalPresenter new
		canvas: (IllimaniRoassalChartBuilder new
			model: self profiler;
			topCalculationsNumber: self topCalculationsNumber;
			allocatedObjectsPerSecondLineChartCanvas);
		yourself
]

{ #category : 'initialization - lazy presenters' }
IllimaniTRoassalPresenters >> initializeAllocationsPerSecondPerAllocator [

	allocationsPerSecondPerAllocatorPresenter := AlternatorPresenter new
		  presenterOne: self allocatedObjectsPerSecondPerClassPresenter withName: 'Classes';
		  presenterTwo: self allocatedObjectsPerSecondPerMethodPresenter withName: 'Methods';
		  yourself
]

{ #category : 'initialization - lazy presenters' }
IllimaniTRoassalPresenters >> initializeHeatmapPresenter [

	| roassalPresenterByClass roassalPresenterByMethod |
	roassalPresenterByClass := self instantiate: SpRoassalPresenter.
	roassalPresenterByClass canvas: (IllimaniRoassalChartBuilder new
			 model: self profiler;
			 topCalculationsNumber: self topCalculationsNumber;
			 heatmapAllocatorAllocatedCanvasByClass).
	roassalPresenterByMethod := self instantiate: SpRoassalPresenter.
	roassalPresenterByMethod canvas: (IllimaniRoassalChartBuilder new
			 model: self profiler;
			 topCalculationsNumber: self topCalculationsNumber;
			 heatmapAllocatorAllocatedCanvasByMethod).

	heatmapPresenter :=( self instantiate: AlternatorPresenter)
		presenterOne: roassalPresenterByClass withName: 'Classes';
		presenterTwo: roassalPresenterByMethod  withName: 'Methods';
		yourself
]
