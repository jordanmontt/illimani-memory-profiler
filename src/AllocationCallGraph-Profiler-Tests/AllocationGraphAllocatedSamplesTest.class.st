Class {
	#name : 'AllocationGraphAllocatedSamplesTest',
	#superclass : 'TestCase',
	#instVars : [
		'samples',
		'allocationGraph',
		'profiler'
	],
	#category : 'AllocationCallGraph-Profiler-Tests',
	#package : 'AllocationCallGraph-Profiler-Tests'
}

{ #category : 'tests' }
AllocationGraphAllocatedSamplesTest >> testAllocatedSamples [

	profiler := FiLiP new
		            samplingRate: 1;
		            profileOn: [ AllocationGraphFixture entryPoint ];
		            yourself.
	samples := profiler objectAllocations select: [ :ephemeron |
		           {  Array. Behavior } includes: ephemeron allocatedObjectClass ].
	allocationGraph := AllocationGraph new
		                   setUpForSamples: samples;
		                   yourself.

	self assert: allocationGraph allocatedSamples size equals: 60.
	self
		assert: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #entryPoint) allocatedSamples size
		equals: 60.

	allocationGraph := allocationGraph pruneFromRoot: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #entryPoint).
	self assert: allocationGraph allocatedSamples size equals: 60.
	self
		assert: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #entryPoint) allocatedSamples size
		equals: 60
]

{ #category : 'tests' }
AllocationGraphAllocatedSamplesTest >> testAllocatedSamplesLongExecution [

	self timeLimit: 5 minutes.

	profiler := FiLiP new
		            profileOn: [ 5 timesRepeat: [ StPlayground open close ] ];
		            yourself.
	samples := profiler objectAllocations.
	allocationGraph := AllocationGraph new
		                   setUpForSamples: samples;
		                   yourself.

	self assert: allocationGraph allocatedSamples size equals: samples size
]

{ #category : 'tests' }
AllocationGraphAllocatedSamplesTest >> testAllocatedSamplesNoFiltering [

	profiler := FiLiP new
		            samplingRate: 1;
		            profileOn: [ AllocationGraphFixture entryPoint ];
		            yourself.
	samples := profiler objectAllocations.
	allocationGraph := AllocationGraph new
		                   setUpForSamples: samples;
		                   yourself.

	self assert: allocationGraph allocatedSamples size equals: profiler objectAllocations size
]
