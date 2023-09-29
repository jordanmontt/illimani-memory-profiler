Extension { #name : 'IllAbstractProfiler' }

{ #category : '*IllimaniUI' }
IllAbstractProfiler >> open [

	^ (self uiClass profiler: self announcer: self illimaniAnnouncer)
		  open;
		  yourself
]

{ #category : '*IllimaniUI' }
IllAbstractProfiler >> uiClass [

	^ IllAllocationStatisticsProfilerUI
]
