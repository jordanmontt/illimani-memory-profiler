Class {
	#name : 'IllAllocationProfilerTest',
	#superclass : 'IllAbstractProfilerTest',
	#category : 'IllimaniProfiler-Tests-Allocations-Profiler',
	#package : 'IllimaniProfiler-Tests',
	#tag : 'Allocations-Profiler'
}

{ #category : 'running' }
IllAllocationProfilerTest >> profilerClass [

	^ IllAllocationProfiler
]

{ #category : 'tests' }
IllAllocationProfilerTest >> testProfileOnCopyExecutionStack [

	profiler
		copyExecutionStack;
		profileOn: [ 10 timesRepeat: [ IllAllocationProfiler new ] ].

	"Take one random allocation to check"
	self assert: profiler objectAllocations last context class equals: Context.

	self assert: profiler objectAllocations size > 100.
	profiler objectAllocations do: [ :alloc | "Stack was copied"
		self assert: alloc context class equals: Context ]
]
