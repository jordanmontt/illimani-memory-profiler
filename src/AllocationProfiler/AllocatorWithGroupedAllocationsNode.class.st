"
I am an object that acts like a node for a collection. I am a data structure that is used to calculate statistics. I know the allocator and I also have the allocated objects grouped by the class of the allocated object.
"
Class {
	#name : #AllocatorWithGroupedAllocationsNode,
	#superclass : #Object,
	#instVars : [
		'allocator',
		'groupedAllocations'
	],
	#category : #'AllocationProfiler-Statistics-Model'
}

{ #category : #api }
AllocatorWithGroupedAllocationsNode >> allocationsOf: aClass [

	^ groupedAllocations at: aClass ifPresent: [ :e | e size ] ifAbsent: [ 0 ]
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

{ #category : #accessing }
AllocatorWithGroupedAllocationsNode >> groupedAllocations [

	^ groupedAllocations
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

	aStream << allocator asString << ' allocated ' << self totalAllocations asString << ' instances that weight ' << self totalSizeInBytes humanReadableByteSizeString
]

{ #category : #api }
AllocatorWithGroupedAllocationsNode >> sortedGroupedAllocations [

	^ (groupedAllocations values sorted: [ :a :b | a size > b size ]) flattened
]

{ #category : #api }
AllocatorWithGroupedAllocationsNode >> sortedGroupedAllocationsAsAssociation [

	^ (groupedAllocations associations sorted: [ :a :b | a value size > b value size ])
		  flattened
]

{ #category : #api }
AllocatorWithGroupedAllocationsNode >> totalAllocations [

	^ groupedAllocations values inject: 0 into: [ :sum :collection | sum + collection size ]
]

{ #category : #api }
AllocatorWithGroupedAllocationsNode >> totalGroupedAllocations [

	^ groupedAllocations values collect: #size
]

{ #category : #accessing }
AllocatorWithGroupedAllocationsNode >> totalSizeInBytes [

	^ groupedAllocations inject: 0
		  into: [ :sum :node | sum + (node sum: [ :e | e totalSizeInBytes ]) ]
]
