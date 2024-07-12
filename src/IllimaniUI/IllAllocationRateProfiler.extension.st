Extension { #name : 'IllAllocationRateProfiler' }

{ #category : '*IllimaniUI' }
IllAllocationRateProfiler >> generalInfoInspector [

	<inspectorPresentationOrder: 0 title: 'Information'>
	^ ProfilerWithAllocationSiteSummaryPresenter on: self
]

{ #category : '*IllimaniUI' }
IllAllocationRateProfiler >> uiClass [

	^ IllAllocationRateProfilerUI
]
