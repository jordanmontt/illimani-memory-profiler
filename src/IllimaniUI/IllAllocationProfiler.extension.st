Extension { #name : 'IllAllocationProfiler' }

{ #category : '*IllimaniUI' }
IllAllocationProfiler >> open [

	^ (IllAllocationProfilerUI profiler: self announcer: illimaniAnnouncer)
		  open;
		  yourself
]
