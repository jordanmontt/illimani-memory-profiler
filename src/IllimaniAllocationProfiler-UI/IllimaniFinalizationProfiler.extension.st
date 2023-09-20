Extension { #name : 'IllimaniFinalizationProfiler' }

{ #category : '*IllimaniAllocationProfiler-UI' }
IllimaniFinalizationProfiler >> open [

	^ (IllimaniFinalizationProfilerUI profiler: self announcer: IllimaniAnnouncer new)
		  open;
		  yourself
]
