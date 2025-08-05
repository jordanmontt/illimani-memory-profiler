"
I am an object that acts like a node for a collection. I am a data structure that is used to calculate statistics. I know the allocator and I also have the allocated objects grouped by the class of the allocated object.
"
Class {
	#name : 'IllGroupedAllocationsByAllocatorNode',
	#superclass : 'Object',
	#instVars : [
		'groupedAllocations',
		'key'
	],
	#category : 'FiLiP-MemoryProfiler-QueryModel',
	#package : 'FiLiP-MemoryProfiler',
	#tag : 'QueryModel'
}

{ #category : 'api' }
IllGroupedAllocationsByAllocatorNode >> allocationsOf: aClass [

	^ groupedAllocations at: aClass ifPresent: [ :e | e size ] ifAbsent: [ 0 ]
]

{ #category : 'accessing' }
IllGroupedAllocationsByAllocatorNode >> groupedAllocations [

	^ groupedAllocations
]

{ #category : 'api' }
IllGroupedAllocationsByAllocatorNode >> increaseAllocationsFor: anAllocationHolder [

	groupedAllocations
		at: anAllocationHolder allocatedObjectClass
		update: [ :anOrderedCollection |
			anOrderedCollection
				add: anAllocationHolder;
				yourself ]
		initial: [ OrderedCollection with: anAllocationHolder ]
]

{ #category : 'initialization' }
IllGroupedAllocationsByAllocatorNode >> initialize [

	super initialize.
	groupedAllocations := Dictionary new
]

{ #category : 'accessing' }
IllGroupedAllocationsByAllocatorNode >> key [

	^ key
]

{ #category : 'accessing' }
IllGroupedAllocationsByAllocatorNode >> key: anObject [

	key := anObject
]

{ #category : 'printing' }
IllGroupedAllocationsByAllocatorNode >> printOn: aStream [

	aStream << key asString << ' allocated ' << self totalAllocations asString << ' instances that weight ' << self totalAllocatedMemory humanReadableByteSizeString
]

{ #category : 'api' }
IllGroupedAllocationsByAllocatorNode >> sortedGroupedAllocations [

	^ (groupedAllocations values sorted: [ :a :b | a size > b size ]) flattened
]

{ #category : 'api' }
IllGroupedAllocationsByAllocatorNode >> summedLifetimes [

	^ groupedAllocations values
		inject: 0
		into: [ :sum :collection | sum + (collection sum: #lifetime) ]
]

{ #category : 'accessing' }
IllGroupedAllocationsByAllocatorNode >> totalAllocatedMemory [

	^ groupedAllocations
		inject: 0
		into: [ :sum :node | sum + (node sum: [ :e | e sizeInBytes ]) ]
]

{ #category : 'api' }
IllGroupedAllocationsByAllocatorNode >> totalAllocations [

	^ groupedAllocations values inject: 0 into: [ :sum :collection | sum + collection size ]
]
