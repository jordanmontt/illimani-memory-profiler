Extension { #name : 'IllAbstractProfiler' }

{ #category : '*IllimaniUI' }
IllAbstractProfiler >> open [

	^ (IllAllocationProfilerUI profiler: self announcer: self illimaniAnnouncer)
		  open;
		  yourself
]
