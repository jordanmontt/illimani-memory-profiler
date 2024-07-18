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
		copyExecutionStack;
		samplingRate: 1;
		startProfiling.
		
	Object illNew.
	
	self assert: profiler objectAllocations first context receiver class equals: self class.
	self assert: profiler objectAllocations first context homeMethod
		equals: self class >> #testFilterContextIgnoringClass
]

{ #category : 'tests' }
IllAllocationSiteProfilerTest >> testProfileOnCopyExecutionStack [

	profiler
		samplingRate: 1;
		copyExecutionStack;
		profileOn: [ 100 timesRepeat: [ Object new ] ].

	"Take one random allocation to check"
	self assert: profiler objectAllocations last context class equals: Context.

	self assert: profiler objectAllocations size >= 100.
	profiler objectAllocations do: [ :alloc | "Stack was copied"
		self assert: alloc context class equals: Context ]
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
