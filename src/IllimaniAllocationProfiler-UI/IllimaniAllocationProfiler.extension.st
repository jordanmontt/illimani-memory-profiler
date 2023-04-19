Extension { #name : #IllimaniAllocationProfiler }

{ #category : #'*IllimaniAllocationProfiler-UI' }
IllimaniAllocationProfiler >> open [

	^ IllimaniAllocationProfilerUI new
		objectAllocationProfiler: self;
		open
]
