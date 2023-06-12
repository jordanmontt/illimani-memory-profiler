Extension { #name : #IllimaniAllocationProfiler }

{ #category : #'*IllimaniAllocationProfiler-UI' }
IllimaniAllocationProfiler >> open [

	^ (IllimaniAllocationProfilerUI illimaniAnnouncer: illimaniAnnouncer)
		  profiler: self;
		  open;
		  yourself
]
