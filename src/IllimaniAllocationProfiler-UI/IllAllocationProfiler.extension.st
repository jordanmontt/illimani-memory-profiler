Extension { #name : 'IllAllocationProfiler' }

{ #category : '*IllimaniAllocationProfiler-UI' }
IllAllocationProfiler >> open [

	^ (IllAllocationProfilerUI profiler: self announcer: illimaniAnnouncer)
		  open;
		  yourself
]
