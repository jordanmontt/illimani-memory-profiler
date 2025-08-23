Class {
	#name : 'AllocationGraphTest',
	#superclass : 'TestCase',
	#instVars : [
		'samples',
		'allocationGraph',
		'profiler'
	],
	#category : 'AllocationCallGraph-Profiler-Tests',
	#package : 'AllocationCallGraph-Profiler-Tests'
}

{ #category : 'running' }
AllocationGraphTest >> setUp [

	super setUp.

	profiler := FiLiP new
			samplingRate: 1;
		   	profileOn: [ AllocationGraphFixture entryPoint ];
			yourself.
	samples := profiler objectAllocations select: [ :ephemeron |
			{  AllocationGraphFixtureArray. AllocationGraphFixtureElement } includes: ephemeron allocatedObjectClass ].
	allocationGraph := AllocationGraph new
			setUpForSamples: samples;
			yourself
]

{ #category : 'tests' }
AllocationGraphTest >> testAllocatedSamplesStayTheSameAfterPruning [

	self assert: allocationGraph allocatedSamples size equals: 60.
	self
		assert: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #entryPoint) allocatedSamples size
		equals: 60.

	allocationGraph := allocationGraph
			pruneFromRoot: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #entryPoint).
	self assert: allocationGraph allocatedSamples size equals: 60.
	self
		assert: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #entryPoint) allocatedSamples size
		equals: 60
]

{ #category : 'tests' }
AllocationGraphTest >> testPruneFromRoot [

	| oldNode |
	oldNode:= allocationGraph nodeAtMethod: AllocationGraphFixture class >> #entryPoint.
	self deny: oldNode isRoot.
	
	allocationGraph := allocationGraph pruneFromRoot: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #entryPoint).
	
	"Check new and old roots"
	self assert: allocationGraph nodes size equals: 12.
	self assert: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #entryPoint) isRoot.
	self deny: oldNode isRoot.
	
	"Check the other nodes"
	self assert: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #entryPoint) allocatedSamples size equals: 60.
	self assert: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #m6) allocatedSamples size equals: 50.
	self assert: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #m7) allocatedSamples size equals: 10.
	self assert: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #m2) allocatedSamples size equals: 5.
	self assert: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #m1) allocatedSamples size equals: 25.
	self assert: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #m3) allocatedSamples size equals: 20.
	self assert: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #m4) allocatedSamples size equals: 5.
	self assert: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #m5) allocatedSamples size equals: 5.
	self assert: (allocationGraph nodeAtMethod: AllocationGraphFixtureUtilities class >> #mm) allocatedSamples size equals: 5.
	
	"Check leaves"
	self assert: (allocationGraph nodeAtMethod: Behavior >> #basicNew) allocatedSamples size equals: 10.
	self assert: (allocationGraph nodeAtMethod: Behavior >> #basicNewTenured) allocatedSamples size equals: 30.
	self assert: (allocationGraph nodeAtMethod: Array class >> #new:) allocatedSamples size equals: 20
]
