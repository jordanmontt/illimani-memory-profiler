"
I am a fixture class to mock some allocations
"
Class {
	#name : 'AllocationStatisticsTestFixture',
	#superclass : 'Object',
	#instVars : [
		'groupedAndSortedByMethodAllocations',
		'mockedAllocations'
	],
	#category : 'IllimaniProfiler-Tests-Model-Statistics',
	#package : 'IllimaniProfiler-Tests',
	#tag : 'Model-Statistics'
}

{ #category : 'fixture' }
AllocationStatisticsTestFixture >> allocationsOne [

	| allocations |
	allocations := OrderedCollection new.
	allocations
		add: (IllEphemeron new
				 allocatorMethod: Margin >> #asMargin;
				 allocatorClass: Margin;
				 allocatedObjectClass: OrderedCollection;
				 programCounter: 10;
				 sizeInBytes: 16;
				 yourself);
		add: (IllEphemeron new
				 allocatorMethod: Margin >> #asMargin;
				 allocatorClass: Margin;
				 allocatedObjectClass: OrderedCollection;
				 sizeInBytes: 16;
				 programCounter: 10;
				 yourself);
		add: (IllEphemeron new
				 allocatorMethod: Margin >> #asMargin;
				 allocatorClass: Margin;
				 allocatedObjectClass: Dictionary;
				 sizeInBytes: 16;
				 programCounter: 10;
				 yourself);
		add: (IllEphemeron new
				 allocatorMethod: Margin >> #asMargin;
				 allocatorClass: Margin;
				 allocatedObjectClass: ByteString;
				 sizeInBytes: 32;
				 programCounter: 10;
				 yourself);
		add: (IllEphemeron new
				 allocatorMethod: Margin >> #asMargin;
				 allocatorClass: Margin;
				 allocatedObjectClass: ByteString;
				 sizeInBytes: 48;
				 programCounter: 10;
				 yourself);
		add: (IllEphemeron new
				 allocatorMethod: Margin >> #asMargin;
				 allocatorClass: Margin;
				 allocatedObjectClass: ByteString;
				 sizeInBytes: 100;
				 programCounter: 10;
				 yourself);
		add: (IllEphemeron new
				 allocatorMethod: Margin >> #asMargin;
				 allocatorClass: Margin;
				 allocatedObjectClass: ByteString;
				 sizeInBytes: 55;
				 programCounter: 10;
				 yourself);
		add: (IllEphemeron new
				 allocatorMethod: Margin >> #asMargin;
				 allocatorClass: Margin;
				 allocatedObjectClass: Color;
				 sizeInBytes: 60;
				 programCounter: 10;
				 programCounter: 10;
				 yourself);
		add: (IllEphemeron new
				 allocatorMethod: Margin >> #asMargin;
				 allocatorClass: Margin;
				 allocatedObjectClass: Color;
				 sizeInBytes: 16;
				 programCounter: 10;
				 programCounter: 10;
				 yourself).
	^ allocations
]

{ #category : 'fixture' }
AllocationStatisticsTestFixture >> allocationsThree [

	| allocations |
	allocations := OrderedCollection new.
	allocations add: (IllEphemeron new
			 allocatorMethod: Collection >> #sorted:;
			 allocatorClass: Collection;
			 allocatedObjectClass: ByteArray;
			 sizeInBytes: 16;
			 programCounter: 10;
			 yourself).
	^ allocations
]

{ #category : 'fixture' }
AllocationStatisticsTestFixture >> allocationsTwo [

	| allocations |
	allocations := OrderedCollection new.
	allocations
		add: (IllEphemeron new
				 allocatorMethod: ArrayedCollection >> #add:;
				 allocatorClass: ArrayedCollection;
				 allocatedObjectClass: ByteString;
				 sizeInBytes: 16;
				 programCounter: 10;
				 yourself);
		add: (IllEphemeron new
				 allocatorMethod: ArrayedCollection >> #add:;
				 allocatorClass: ArrayedCollection;
				 allocatedObjectClass: ByteString;
				 programCounter: 10;
				 sizeInBytes: 16;
				 yourself);
		add: (IllEphemeron new
				 allocatorMethod: ArrayedCollection >> #add:;
				 allocatorClass: ArrayedCollection;
				 allocatedObjectClass: ByteString;
				 programCounter: 10;
				 sizeInBytes: 32;
				 yourself);
		add: (IllEphemeron new
				 allocatorMethod: ArrayedCollection >> #add:;
				 allocatorClass: ArrayedCollection;
				 allocatedObjectClass: ByteArray;
				 programCounter: 10;
				 sizeInBytes: 100;
				 yourself);
		add: (IllEphemeron new
				 allocatorMethod: ArrayedCollection >> #add:;
				 allocatorClass: ArrayedCollection;
				 allocatedObjectClass: ByteArray;
				 programCounter: 10;
				 sizeInBytes: 16;
				 yourself).
	^ allocations
]

{ #category : 'fixture' }
AllocationStatisticsTestFixture >> groupAndSortByAllocatedClass: someAllocations [

	| groupedAllocations |
	groupedAllocations := Dictionary new.
	someAllocations do: [ :allocationInfo |
		groupedAllocations
			at: allocationInfo allocatedObjectClass
			update: [ :col |
				col
					add: allocationInfo;
					yourself ]
			initial: [ OrderedCollection with: allocationInfo ] ].
	^ groupedAllocations associations sorted: [ :a :b | a value size > b value size ]
]

{ #category : 'fixture' }
AllocationStatisticsTestFixture >> groupedAndSortedByClassAllocator [

	^ self mockedAllocations collect: [ :e | e allocatorClass ] as: Set
]

{ #category : 'fixture' }
AllocationStatisticsTestFixture >> groupedAndSortedByMethodAllocators [

	| dict |
	dict := Dictionary new.

	self mockedAllocations do: [ :allo |
		dict
			at: allo allocationSite
			update: [ :e |
				e
					add: allo;
					yourself ]
			initial: [ OrderedCollection with: allo ] ].

	^ (dict associations sort: [ :a :b | a value size > b value size ]) collect: [ :e |
		  e key -> (self groupAndSortByAllocatedClass: e value) ]
]

{ #category : 'initialization' }
AllocationStatisticsTestFixture >> initialize [

	super initialize.
	mockedAllocations := self allocationsThree , self allocationsTwo , self allocationsOne.
	groupedAndSortedByMethodAllocations := self groupedAndSortedByMethodAllocators
]

{ #category : 'fixture' }
AllocationStatisticsTestFixture >> mockedAllocations [

	^ mockedAllocations
]
