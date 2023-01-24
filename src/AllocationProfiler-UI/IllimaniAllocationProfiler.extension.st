Extension { #name : #IllimaniAllocationProfiler }

{ #category : #'*AllocationProfiler-UI' }
IllimaniAllocationProfiler >> open [

	^ IllimaniAllocationProfilerUI new
		  objectAllocationProfiler: self;
		  open
]
