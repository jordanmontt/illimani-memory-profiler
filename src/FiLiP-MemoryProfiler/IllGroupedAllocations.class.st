"
I am an object that acts like a collection. I am only used to calculate statistics and I am used because my api facilitates the calculations.
"
Class {
	#name : 'IllGroupedAllocations',
	#superclass : 'Object',
	#instVars : [
		'sortedByTotalAllocationsNodes',
		'groupedNodesDictionary',
		'sortedByLifetimeNodes'
	],
	#category : 'FiLiP-MemoryProfiler-QueryModel',
	#package : 'FiLiP-MemoryProfiler',
	#tag : 'QueryModel'
}

{ #category : 'converting' }
IllGroupedAllocations >> asOrderedCollection [

	^ self sortedByTotalAllocations
]

{ #category : 'accessing' }
IllGroupedAllocations >> groupedNodesDictionary [

	^ groupedNodesDictionary
]

{ #category : 'initialization' }
IllGroupedAllocations >> initialize [

	super initialize.
	groupedNodesDictionary := Dictionary new
]

{ #category : 'inspector - extensions' }
IllGroupedAllocations >> inspectorExtension [

	<inspectorPresentationOrder: 0 title: 'Title'>
	^ SpListPresenter new
		  items: self asOrderedCollection;
		  yourself
]

{ #category : 'api' }
IllGroupedAllocations >> sortByLifetime [

	sortedByLifetimeNodes := groupedNodesDictionary sorted: [ :a :b |
		a value summedLifetimes > b value summedLifetimes ]
]

{ #category : 'api' }
IllGroupedAllocations >> sortByNumberOfAllocations [

	sortedByTotalAllocationsNodes := groupedNodesDictionary sorted: [ :a :b |
		a value totalAllocations > b value totalAllocations ]
]

{ #category : 'api' }
IllGroupedAllocations >> sortedByLifetime [

	sortedByLifetimeNodes ifNil: [ self sortByLifetime ].
	^ sortedByLifetimeNodes
]

{ #category : 'api' }
IllGroupedAllocations >> sortedByTotalAllocations [

	sortedByTotalAllocationsNodes ifNil: [ self sortByNumberOfAllocations ].
	^ sortedByTotalAllocationsNodes
]

{ #category : 'api' }
IllGroupedAllocations >> updateAllocationForKey: allocator allocation: anAllocationHolder [

	groupedNodesDictionary at: allocator
		ifPresent: [ :subDictionary | subDictionary increaseAllocationsFor: anAllocationHolder ]
		ifAbsentPut: [
			IllGroupedAllocationsByAllocatorNode new
				key: allocator;
				increaseAllocationsFor: anAllocationHolder;
				yourself ]
]
