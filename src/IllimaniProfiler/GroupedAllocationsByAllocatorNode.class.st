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

{ #category : 'inspector - extensions' }
GroupedAllocationsByAllocatorNode >> inspectorExtension: aBuilder [

	<inspectorPresentationOrder: 0 title: 'Summary'>
	| elements tablePresenter |
	elements := { 'Allocator' -> allocator . 'Total allocations' -> self totalAllocations . 'Total size in memory' -> self sizeInBytes }.
	tablePresenter := aBuilder newTable.
	tablePresenter
		addColumn: (SpStringTableColumn title: 'Name' evaluated: #key);
		addColumn: (SpStringTableColumn title: 'Value' evaluated: #value);
		items: (elements collect: [ :e | StInspectorAssociationNode hostObject: e ]);
		beResizable.
	^ tablePresenter
]

{ #category : 'inspector - extensions' }
GroupedAllocationsByAllocatorNode >> inspectorExtensionGroupedAllocations: aBuilder [

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
