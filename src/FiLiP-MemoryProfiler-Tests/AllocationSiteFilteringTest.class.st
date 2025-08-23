Class {
	#name : 'AllocationSiteFilteringTest',
	#superclass : 'TestCase',
	#instVars : [
		'profiler'
	],
	#category : 'FiLiP-MemoryProfiler-Tests',
	#package : 'FiLiP-MemoryProfiler-Tests'
}

{ #category : 'running' }
AllocationSiteFilteringTest >> setUp [

	super setUp.
	profiler := FiLiP new
]

{ #category : 'running' }
AllocationSiteFilteringTest >> tearDown [

	profiler forceUninstall.
	profiler := nil.
	super tearDown
]

{ #category : 'tests' }
AllocationSiteFilteringTest >> testFilterContextIgnoringClass [

	profiler
		instrumentator: (IllMockInstrumentator onProfiler: profiler);
		samplingRate: 1;
		startProfiling.

	Object illNew.

	self
		assert: profiler objectAllocations first textualAllocatorMethod methodClass
		equals: self class.
	self
		assert: profiler objectAllocations first textualAllocatorMethod selector
		equals: #testFilterContextIgnoringClass.
	self
		assert: profiler objectAllocations first textualAllocatorMethod
		equals: self class >> #testFilterContextIgnoringClass
]
