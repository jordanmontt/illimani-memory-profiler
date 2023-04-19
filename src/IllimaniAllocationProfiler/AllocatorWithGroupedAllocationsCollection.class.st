"
I am an object that acts like a collection. I am only used to calculate statistics and I am used because my api facilitates the calculations.
"
Class {
	#name : #AllocatorWithGroupedAllocationsCollection,
	#superclass : #Object,
	#instVars : [
		'sortedByTotalAllocationsNodes',
		'groupedNodesDictionary'
	],
	#category : #'IllimaniAllocationProfiler-Statistics-Model'
}

{ #category : #converting }
AllocatorWithGroupedAllocationsCollection >> asOrderedCollection [

	^ self sortedByTotalAllocations
]

{ #category : #accessing }
AllocatorWithGroupedAllocationsCollection >> groupedNodesDictionary [

	^ groupedNodesDictionary
]

{ #category : #initialization }
AllocatorWithGroupedAllocationsCollection >> initialize [

	super initialize.
	groupedNodesDictionary := Dictionary new
]

{ #category : #api }
AllocatorWithGroupedAllocationsCollection >> sort [

	sortedByTotalAllocationsNodes := groupedNodesDictionary sorted: [ :a :b |
		               a value totalAllocations > b value totalAllocations ]
]

{ #category : #api }
AllocatorWithGroupedAllocationsCollection >> sortedByTotalAllocations [

	sortedByTotalAllocationsNodes ifNil: [ self sort ].
	^ sortedByTotalAllocationsNodes
]

{ #category : #accessing }
AllocatorWithGroupedAllocationsCollection >> updateAllocationForAllocator: allocator allocation: anAllocationHolder [

	groupedNodesDictionary at: allocator
		ifPresent: [ :subDictionary | subDictionary increaseAllocationsFor: anAllocationHolder ]
		ifAbsentPut: [
			AllocatorWithGroupedAllocationsNode new
				allocator: allocator;
				increaseAllocationsFor: anAllocationHolder;
				yourself ]
]
