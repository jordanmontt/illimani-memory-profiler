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
	#category : 'IllimaniProfiler-Model-Statistics',
	#package : 'IllimaniProfiler',
	#tag : 'Model-Statistics'
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

{ #category : 'inspector - extensions' }
IllGroupedAllocationsByAllocatorNode >> inspectorExtension: aBuilder [

	<inspectorPresentationOrder: 0 title: 'Summary'>
	| elements tablePresenter |
	elements := { 'Allocator' -> "because of block closures" key . 'Total allocations' -> self totalAllocations . 'Total size in memory' -> self totalAllocatedMemory humanReadableByteSizeString }.
	tablePresenter := aBuilder newTable.
	tablePresenter
		addColumn: (SpStringTableColumn title: 'Name' evaluated: #key);
		addColumn: (SpStringTableColumn title: 'Value' evaluated: #value);
		items: (elements collect: [ :e | StInspectorAssociationNode hostObject: e ]);
		beResizable.
	^ tablePresenter
]

{ #category : 'inspector - extensions' }
IllGroupedAllocationsByAllocatorNode >> inspectorExtensionGroupedAllocations: aBuilder [

	<inspectorPresentationOrder: 1 title: 'Grouped Allocations'>
	| tablePresenter |
	tablePresenter := aBuilder newTable.
	tablePresenter
		addColumn: (SpStringTableColumn
			title: 'Key'
			evaluated: [ :each | StObjectPrinter asTruncatedTextFrom: each key ]) beSortable;
		addColumn: (SpStringTableColumn
			title: 'Value'
			evaluated: [ :each | each value size asString , ' instances' ]) beSortable;
		items: (groupedAllocations associations collect: [ :e |
			StInspectorAssociationNode hostObject: e ]).
	^ tablePresenter
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
