"
I am an object that acts like a node for a collection. I am a data structure that is used to calculate statistics. I know the allocator and I also have the allocated objects grouped by the class of the allocated object.
"
Class {
	#name : #AllocatorWithGroupedAllocationsNode,
	#superclass : #Object,
	#instVars : [
		'allocator',
		'groupedAllocations',
		'totalMemorySize'
	],
	#category : #'AllocationProfiler-Statistics-Model'
}

{ #category : #api }
AllocatorWithGroupedAllocationsNode >> allocationsOf: aClass [

	^ groupedAllocations at: aClass ifAbsent: [ 0 ]
]

{ #category : #accessing }
AllocatorWithGroupedAllocationsNode >> allocator [

	^ allocator
]

{ #category : #accessing }
AllocatorWithGroupedAllocationsNode >> allocator: anObject [

	allocator := anObject
]

{ #category : #api }
AllocatorWithGroupedAllocationsNode >> eachAllocationsTotal [

	^ groupedAllocations values
]

{ #category : #api }
AllocatorWithGroupedAllocationsNode >> increaseAllocationsFor: anAllocationHolder [

	groupedAllocations
		at: anAllocationHolder allocatedObjectClass
		update: [ :anOrderedCollection |
			anOrderedCollection
				add: anAllocationHolder;
				yourself ]
		initial: [ OrderedCollection with: anAllocationHolder ]
]

{ #category : #initialization }
AllocatorWithGroupedAllocationsNode >> initialize [

	super initialize.
	groupedAllocations := Dictionary new
]

{ #category : #printing }
AllocatorWithGroupedAllocationsNode >> printOn: aStream [

	aStream << allocator asString << ' allocated ' << self totalAllocations asString << ' instances'
]

{ #category : #api }
AllocatorWithGroupedAllocationsNode >> sortedGroupedAllocations [

	^ groupedAllocations associations sorted: [ :a :b | a value size > b value size ]
]

{ #category : #api }
AllocatorWithGroupedAllocationsNode >> totalAllocations [

	^ groupedAllocations values inject: 0 into: [ :sum :collection | sum + collection size ]
]

{ #category : #accessing }
AllocatorWithGroupedAllocationsNode >> totalMemorySize [

	^ totalMemorySize
]

{ #category : #accessing }
AllocatorWithGroupedAllocationsNode >> totalMemorySize: anObject [

	totalMemorySize := anObject
]
