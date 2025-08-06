Class {
	#name : 'AllocationGraphTest',
	#superclass : 'TestCase',
	#instVars : [
		'allocationGraph'
	],
	#category : 'AllocationCallGraph-Profiler-Tests',
	#package : 'AllocationCallGraph-Profiler-Tests'
}

{ #category : 'running' }
AllocationGraphTest >> setUp [

	| profiler samples |
	super setUp.
	profiler := FiLiP new
		            samplingRate: 1;
		            profileOn: [ AllocationGraphFixture entryPoint ];
		            yourself.
	samples := profiler objectAllocations select: [ :ephemeron |
		           { Array. Behavior } includes: ephemeron allocatedObjectClass ].
	allocationGraph := AllocationGraph new
		                   setUpForSamples: samples;
		                   yourself.
	
	allocationGraph edges do: #beLongLived.
]

{ #category : 'tests' }
AllocationGraphTest >> testAllPathsFromTo [

	| actualPaths expectedPaths |
	
	actualPaths := allocationGraph
			allPathsFrom: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #m7)
			to: (allocationGraph nodeAtMethod: Behavior >> #basicNewTenured).
	expectedPaths := {
		                 {
			                 (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #m7).
			                 (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #m5).
			                 (allocationGraph nodeAtMethod: Behavior >> #basicNewTenured) }.
		                 {
			                 (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #m7).
			                 (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #m4).
			                 (allocationGraph nodeAtMethod: Behavior >> #basicNewTenured) } }.

	self assert: actualPaths size equals: 2.
	self assertCollection: actualPaths includesAll: expectedPaths.
]

{ #category : 'tests' }
AllocationGraphTest >> testAllocationPaths [

	| m2Node basicNewNode expectedPath actualPath |
	allocationGraph identifyAllocationSitesUsing:
		(MethodFromTheSamePackageStrategy packagesToMatch: { self class package }).
	m2Node := allocationGraph nodeAtMethod: AllocationGraphFixture class >> #m2.
	basicNewNode := allocationGraph nodeAtMethod: Behavior >> #basicNew.
	expectedPath := (allocationGraph allPathsFrom: m2Node to: basicNewNode) first.
	actualPath := m2Node allocationPaths first.

	actualPath := ( { actualPath first targetNode . actualPath first sourceNode }) , 
			(actualPath allButFirst collect: #sourceNode).
	self assertCollection: actualPath reversed equals: expectedPath
]

{ #category : 'tests' }
AllocationGraphTest >> testAllocationSiteDetectionAfterPruning [

	allocationGraph := allocationGraph pruneFromRoot: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #entryPoint).
	allocationGraph identifyAllocationSitesUsing: TextualLocationOfNewStrategy new.

	self assert: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #m1) isAllocationSite.
	self assert: (allocationGraph nodeAtMethod: AllocationGraphFixtureUtilities class >> #mm) isAllocationSite.	
	self assert: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #m3) isAllocationSite.
	self assert: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #m4) isAllocationSite.
	self assert: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #m5) isAllocationSite.

	self deny: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #m2) isAllocationSite.
	self deny: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #m6) isAllocationSite.
	self deny: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #m7) isAllocationSite.
	self deny: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #entryPoint) isAllocationSite
]

{ #category : 'tests' }
AllocationGraphTest >> testAllocationSiteDetectionAfterPruningMethodInPackage [

	allocationGraph := allocationGraph pruneFromRoot: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #entryPoint).
	allocationGraph identifyAllocationSitesUsing:
		(MethodFromTheSamePackageStrategy packagesToMatch: { self class package }).

	self assert: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #m1) isAllocationSite.
	self assert: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #m2) isAllocationSite.
	self assert: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #m3) isAllocationSite.
	self assert: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #m4) isAllocationSite.
	self assert: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #m5) isAllocationSite.

	self deny: (allocationGraph nodeAtMethod: AllocationGraphFixtureUtilities class >> #mm) isAllocationSite.	
	self deny: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #m6) isAllocationSite.
	self deny: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #m7) isAllocationSite.
	self deny: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #entryPoint) isAllocationSite
]

{ #category : 'tests' }
AllocationGraphTest >> testDetectAllocationSiteDefault [

	allocationGraph identifyAllocationSitesUsing: TextualLocationOfNewStrategy new.

	self assert: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #m1) isAllocationSite.
	self assert: (allocationGraph nodeAtMethod: AllocationGraphFixtureUtilities class >> #mm) isAllocationSite.	
	self assert: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #m3) isAllocationSite.
	self assert: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #m4) isAllocationSite.
	self assert: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #m5) isAllocationSite.

	self deny: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #m2) isAllocationSite.
	self deny: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #m6) isAllocationSite.
	self deny: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #m7) isAllocationSite.
	self deny: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #entryPoint) isAllocationSite
]

{ #category : 'tests' }
AllocationGraphTest >> testDetectAllocationSitesUsingMethodInPackage [

	allocationGraph identifyAllocationSitesUsing:
		(MethodFromTheSamePackageStrategy packagesToMatch: { self class package }).

	self assert: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #m1) isAllocationSite.
	self assert: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #m2) isAllocationSite.
	self assert: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #m3) isAllocationSite.
	self assert: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #m4) isAllocationSite.
	self assert: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #m5) isAllocationSite.

	self deny: (allocationGraph nodeAtMethod: AllocationGraphFixtureUtilities class >> #mm) isAllocationSite.
	self deny: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #m6) isAllocationSite.
	self deny: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #m7) isAllocationSite.
	self deny: (allocationGraph nodeAtMethod: AllocationGraphFixture class >> #entryPoint) isAllocationSite
]

{ #category : 'tests' }
AllocationGraphTest >> testLeaves [

	| expectedLeaveSelectors |
	expectedLeaveSelectors := { #basicNew. #new:. #basicNewTenured }.
	self assert: allocationGraph leaves size equals: 3.
	self
		assertCollection: (allocationGraph leaves collect: [ :e | e method selector ])
		hasSameElements: expectedLeaveSelectors
]

{ #category : 'tests' }
AllocationGraphTest >> testPruneGraphFromRoot [

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
