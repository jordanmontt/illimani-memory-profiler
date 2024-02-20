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
IllAllocationSiteProfilerTest >> testProfileOnCopyExecutionStack [

	profiler
		copyExecutionStack;
		profileOn: [ 10 timesRepeat: [ IllAllocationSiteProfiler new ] ].

	"Take one random allocation to check"
	self assert: profiler objectAllocations last context class equals: Context.

	self assert: profiler objectAllocations size > 100.
	profiler objectAllocations do: [ :alloc | "Stack was copied"
		self assert: alloc context class equals: Context ]
]

{ #category : 'tests' }
IllAllocationSiteProfilerTest >> testProfileOnSimpleMoreAllocations [

	profiler profileOn: [ 1000 timesRepeat: [ self profilerClass new ] ].

	self assert: profiler objectAllocations size > 1000.
	profiler objectAllocations do: [ :alloc |
		self assert: alloc allocatedObjectClass isClass ]
]
