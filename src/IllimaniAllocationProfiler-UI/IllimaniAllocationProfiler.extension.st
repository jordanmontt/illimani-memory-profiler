Extension { #name : #IllimaniAllocationProfiler }

{ #category : #'*IllimaniAllocationProfiler-UI' }
IllimaniAllocationProfiler >> open [

	^ (IllimaniAllocationProfilerUI illimaniAnnouncer: illimaniAnnouncer)
		  objectAllocationProfiler: self;
		  open;
		  yourself
]
