Extension { #name : 'IllimaniAllocationProfiler' }

{ #category : '*IllimaniAllocationProfiler-UI' }
IllimaniAllocationProfiler >> open [

	^ (IllimaniAllocationProfilerUI profiler: self announcer: illimaniAnnouncer)
		  open;
		  yourself
]
