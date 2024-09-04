"
I am an object that acts like a collection. I am only used to calculate statistics and I am used because my api facilitates the calculations.
"
Class {
	#name : 'GroupedAllocationsByAllocatorCollection',
	#superclass : 'Object',
	#instVars : [
		'sortedByTotalAllocationsNodes',
		'groupedNodesDictionary',
		'sortedByLifetimeNodes'
	],
	#category : 'IllimaniProfiler-Model-Statistics',
	#package : 'IllimaniProfiler',
	#tag : 'Model-Statistics'
}

{ #category : 'converting' }
GroupedAllocationsByAllocatorCollection >> asOrderedCollection [

	^ self sortedByTotalAllocations
]

{ #category : 'accessing' }
GroupedAllocationsByAllocatorCollection >> groupedNodesDictionary [

	^ groupedNodesDictionary
]

{ #category : 'initialization' }
GroupedAllocationsByAllocatorCollection >> initialize [

	super initialize.
	groupedNodesDictionary := Dictionary new
]

{ #category : 'inspector - extensions' }
GroupedAllocationsByAllocatorCollection >> inspectorExtension [

	<inspectorPresentationOrder: 0 title: 'Title'>
	^ SpListPresenter new
		  items: self asOrderedCollection;
		  yourself
]

{ #category : 'api' }
GroupedAllocationsByAllocatorCollection >> sortByLifetime [

	sortedByLifetimeNodes := groupedNodesDictionary sorted: [ :a :b |
		a value summedLifetimes > b value summedLifetimes ]
]

{ #category : 'api' }
GroupedAllocationsByAllocatorCollection >> sortByNumberOfAllocations [

	sortedByTotalAllocationsNodes := groupedNodesDictionary sorted: [ :a :b |
		a value totalAllocations > b value totalAllocations ]
]

{ #category : 'api' }
GroupedAllocationsByAllocatorCollection >> sortedByLifetime [

	sortedByLifetimeNodes ifNil: [ self sortByLifetime ].
	^ sortedByLifetimeNodes
]

{ #category : 'api' }
GroupedAllocationsByAllocatorCollection >> sortedByTotalAllocations [

	sortedByTotalAllocationsNodes ifNil: [ self sortByNumberOfAllocations ].
	^ sortedByTotalAllocationsNodes
]

{ #category : 'api' }
GroupedAllocationsByAllocatorCollection >> updateAllocationForAllocator: allocator allocation: anAllocationHolder [

	groupedNodesDictionary at: allocator
		ifPresent: [ :subDictionary | subDictionary increaseAllocationsFor: anAllocationHolder ]
		ifAbsentPut: [
			GroupedAllocationsByAllocatorNode new
				allocator: allocator;
				increaseAllocationsFor: anAllocationHolder;
				yourself ]
]
