"
I am an object that acts like a collection. I am only used to calculate statistics and I am used because my api facilitates the calculations.
"
Class {
	#name : #AllocatorWithGroupedAllocationsCollection,
	#superclass : #Object,
	#instVars : [
		'nodesTable',
		'sortedNodes'
	],
	#category : #'AllocationProfiler-Statistics-Model'
}

{ #category : #initialization }
AllocatorWithGroupedAllocationsCollection >> initialize [

	super initialize.
	nodesTable := Dictionary new
]

{ #category : #api }
AllocatorWithGroupedAllocationsCollection >> sorted [

	^ sortedNodes ifNil: [
		  sortedNodes := nodesTable sorted: [ :a :b | a value totalAllocations > b value totalAllocations ] ]
]

{ #category : #accessing }
AllocatorWithGroupedAllocationsCollection >> updateAllocationForAllocator: allocator allocation: anAllocationHolder [

	nodesTable at: allocator
		ifPresent: [ :subDictionary | subDictionary increaseAllocationsFor: anAllocationHolder ]
		ifAbsentPut: [
			AllocatorWithGroupedAllocationsNode new
				allocator: allocator;
				increaseAllocationsFor: anAllocationHolder;
				yourself ]
]
