"
I am an object that acts like a node for a collection. I am a data structure that is used to calculate statistics. I know the allocator and I also have the allocated objects grouped by the class of the allocated object.
"
Class {
	#name : 'GroupedAllocationsByAllocatorNode',
	#superclass : 'Object',
	#instVars : [
		'allocator',
		'groupedAllocations'
	],
	#category : 'IllimaniProfiler-Model-Statistics',
	#package : 'IllimaniProfiler',
	#tag : 'Model-Statistics'
}

{ #category : 'api' }
GroupedAllocationsByAllocatorNode >> allocationsOf: aClass [

	^ groupedAllocations at: aClass ifPresent: [ :e | e size ] ifAbsent: [ 0 ]
]

{ #category : 'accessing' }
GroupedAllocationsByAllocatorNode >> allocator [

	^ allocator
]

{ #category : 'accessing' }
GroupedAllocationsByAllocatorNode >> allocator: anObject [

	allocator := anObject
]

{ #category : 'api' }
GroupedAllocationsByAllocatorNode >> eachAllocationsTotal [

	^ groupedAllocations values
]

{ #category : 'accessing' }
GroupedAllocationsByAllocatorNode >> groupedAllocations [

	^ groupedAllocations
]

{ #category : 'api' }
GroupedAllocationsByAllocatorNode >> increaseAllocationsFor: anAllocationHolder [

	groupedAllocations
		at: anAllocationHolder allocatedObjectClass
		update: [ :anOrderedCollection |
			anOrderedCollection
				add: anAllocationHolder;
				yourself ]
		initial: [ OrderedCollection with: anAllocationHolder ]
]

{ #category : 'initialization' }
GroupedAllocationsByAllocatorNode >> initialize [

	super initialize.
	groupedAllocations := Dictionary new
]

{ #category : 'printing' }
GroupedAllocationsByAllocatorNode >> printOn: aStream [

	aStream << allocator asString << ' allocated ' << self totalAllocations asString << ' instances that weight ' << self sizeInBytes humanReadableByteSizeString
]

{ #category : 'accessing' }
GroupedAllocationsByAllocatorNode >> sizeInBytes [

	^ groupedAllocations inject: 0
		  into: [ :sum :node | sum + (node sum: [ :e | e sizeInBytes ]) ]
]

{ #category : 'api' }
GroupedAllocationsByAllocatorNode >> sortedGroupedAllocations [

	^ (groupedAllocations values sorted: [ :a :b | a size > b size ]) flattened
]

{ #category : 'api' }
GroupedAllocationsByAllocatorNode >> sortedGroupedAllocationsAsAssociation [

	^ (groupedAllocations associations sorted: [ :a :b | a value size > b value size ])
		  flattened
]

{ #category : 'api' }
GroupedAllocationsByAllocatorNode >> totalAllocations [

	^ groupedAllocations values inject: 0 into: [ :sum :collection | sum + collection size ]
]

{ #category : 'api' }
GroupedAllocationsByAllocatorNode >> totalGroupedAllocations [

	^ groupedAllocations values collect: #size
]
