Class {
	#name : 'AllocationGraphFixture',
	#superclass : 'Object',
	#category : 'AllocationCallGraph-Profiler-Tests',
	#package : 'AllocationCallGraph-Profiler-Tests'
}

{ #category : 'as yet unclassified' }
AllocationGraphFixture class >> entryPoint [
	"prim1 -> Behavior >> #basicNew
	prim2 -> Array >> #new: 2
	prim3 -> Behavior >> #basicNewTenured"
	self m6.
	self m7
]

{ #category : 'as yet unclassified' }
AllocationGraphFixture class >> m1 [

	5 timesRepeat: [ AllocationGraphFixtureElement basicNew ].
	20 timesRepeat: [ AllocationGraphFixtureArray new: 0 ]
]

{ #category : 'as yet unclassified' }
AllocationGraphFixture class >> m2 [
	"calling method from another package"

	AllocationGraphFixtureUtilities mm
]

{ #category : 'as yet unclassified' }
AllocationGraphFixture class >> m3 [

	20 timesRepeat: [ AllocationGraphFixtureElement basicNewTenured ]
]

{ #category : 'as yet unclassified' }
AllocationGraphFixture class >> m4 [

	5 timesRepeat: [ AllocationGraphFixtureElement basicNewTenured ]
]

{ #category : 'as yet unclassified' }
AllocationGraphFixture class >> m5 [

	5 timesRepeat: [ AllocationGraphFixtureElement basicNewTenured ]
]

{ #category : 'as yet unclassified' }
AllocationGraphFixture class >> m6 [

	self m2.
	self m1.
	self m3
]

{ #category : 'as yet unclassified' }
AllocationGraphFixture class >> m7 [

	self m4.
	self m5
]
