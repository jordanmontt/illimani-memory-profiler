Class {
	#name : 'IllAllocationSiteProfilerTest',
	#superclass : 'IllAbstractProfilerTest',
	#category : 'IllimaniProfiler-Tests-Allocations-Profiler',
	#package : 'IllimaniProfiler-Tests',
	#tag : 'Allocations-Profiler'
}

{ #category : 'running' }
IllAllocationSiteProfilerTest >> profilerClass [

	^ IllAllocationSiteProfiler
]

{ #category : 'tests' }
IllAllocationSiteProfilerTest >> testFilterContextIgnoringClass [

	profiler
		instrumentator: (IllMockInstrumentator onProfiler: profiler);
		samplingRate: 1;
		startProfiling.

	Object illNew.

	self assert: profiler objectAllocations first contextFingerprint first methodClass equals: self class.
	self assert: profiler objectAllocations first contextFingerprint first
		equals: self class >> #testFilterContextIgnoringClass
]

{ #category : 'tests' }
IllAllocationSiteProfilerTest >> testProfileOnSimpleMoreAllocations [

	profiler
		samplingRate: 1;
		profileOn: [ 1000 timesRepeat: [ Object new ] ].

	self assert: profiler objectAllocations size >= 1000.
	profiler objectAllocations do: [ :alloc |
		self assert: alloc allocatedObjectClass isClass ]
]
