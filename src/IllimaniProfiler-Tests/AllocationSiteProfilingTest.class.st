Class {
	#name : 'AllocationSiteProfilingTest',
	#superclass : 'TestCase',
	#instVars : [
		'profiler'
	],
	#category : 'IllimaniProfiler-Tests-Allocations-Profiler',
	#package : 'IllimaniProfiler-Tests',
	#tag : 'Allocations-Profiler'
}

{ #category : 'running' }
AllocationSiteProfilingTest >> setUp [

	super setUp.
	profiler := IllMemoryProfiler new
]

{ #category : 'running' }
AllocationSiteProfilingTest >> tearDown [

	profiler forceUninstall.
	profiler := nil.
	super tearDown
]

{ #category : 'tests' }
AllocationSiteProfilingTest >> testFilterContextIgnoringClass [

	profiler
		instrumentator: (IllMockInstrumentator onProfiler: profiler);
		samplingRate: 1;
		startProfiling.

	Object illNew.

	self
		assert: profiler objectAllocations first allocationSite methodClass
		equals: self class.
	self
		assert: profiler objectAllocations first allocationSite selector
		equals: #testFilterContextIgnoringClass.
	self
		assert: profiler objectAllocations first allocationSite
		equals: self class >> #testFilterContextIgnoringClass
]
