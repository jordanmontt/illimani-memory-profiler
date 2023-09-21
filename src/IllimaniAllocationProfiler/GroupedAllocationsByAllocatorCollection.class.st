"
I am an object that acts like a collection. I am only used to calculate statistics and I am used because my api facilitates the calculations.
"
Class {
	#name : 'GroupedAllocationsByAllocatorCollection',
	#superclass : 'Object',
	#instVars : [
		'sortedByTotalAllocationsNodes',
		'groupedNodesDictionary'
	],
	#category : 'IllimaniAllocationProfiler-Statistics-Model',
	#package : 'IllimaniAllocationProfiler',
	#tag : 'Statistics-Model'
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

{ #category : 'api' }
GroupedAllocationsByAllocatorCollection >> sort [

	sortedByTotalAllocationsNodes := groupedNodesDictionary sorted: [ :a :b |
		a value totalAllocations > b value totalAllocations ]
]

{ #category : 'api' }
GroupedAllocationsByAllocatorCollection >> sortedByTotalAllocations [

	sortedByTotalAllocationsNodes ifNil: [ self sort ].
	^ sortedByTotalAllocationsNodes
]

{ #category : 'accessing' }
GroupedAllocationsByAllocatorCollection >> updateAllocationForAllocator: allocator allocation: anAllocationHolder [

	groupedNodesDictionary at: allocator
		ifPresent: [ :subDictionary | subDictionary increaseAllocationsFor: anAllocationHolder ]
		ifAbsentPut: [
			GroupedAllocationsByAllocatorNode new
				allocator: allocator;
				increaseAllocationsFor: anAllocationHolder;
				yourself ]
]
