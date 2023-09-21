Extension { #name : 'IllFinalizationProfiler' }

{ #category : '*IllimaniAllocationProfiler-UI' }
IllFinalizationProfiler >> open [

	^ (IllFinalizationProfilerUI profiler: self announcer: IllAnnouncer new)
		  open;
		  yourself
]
