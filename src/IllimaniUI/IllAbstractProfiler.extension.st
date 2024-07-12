Extension { #name : 'IllAbstractProfiler' }

{ #category : '*IllimaniUI' }
IllAbstractProfiler >> generalInfoInspector [

	<inspectorPresentationOrder: 0 title: 'Information'>
	^ ProfilerSummaryPresenter on: self
]

{ #category : '*IllimaniUI' }
IllAbstractProfiler >> open [

	^ (self uiClass profiler: self announcer: self illimaniAnnouncer)
		  open;
		  yourself
]

{ #category : '*IllimaniUI' }
IllAbstractProfiler >> uiClass [

	^ self subclassResponsibility
]
