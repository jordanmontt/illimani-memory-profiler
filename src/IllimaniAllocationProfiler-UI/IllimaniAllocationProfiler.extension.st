Extension { #name : #IllimaniAllocationProfiler }

{ #category : #'*IllimaniAllocationProfiler-UI' }
IllimaniAllocationProfiler >> open [

	^ IllimaniAllocationProfilerUI new
		  illimaniAnnouncer: illimaniAnnouncer;
		  objectAllocationProfiler: self;
		  open
]
