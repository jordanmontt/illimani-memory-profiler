"
I am a fixture class to mock some allocations
"
Class {
	#name : 'AllocationStatisticsTestFixture',
	#superclass : 'Object',
	#instVars : [
		'groupedAndSortedByClassAllocations',
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
		add: (AllocationSiteInfoModel new
				 allocatorClass: Rectangle;
				 allocatorMethod: Margin >> #asMargin;
				 allocatedObjectClass: OrderedCollection;
				 sizeInBytes: 16;
				 yourself);
		add: (AllocationSiteInfoModel new
				 allocatorClass: Rectangle;
				 allocatorMethod: Margin >> #asMargin;
				 allocatedObjectClass: OrderedCollection;
				 sizeInBytes: 16;
				 yourself);
		add: (AllocationSiteInfoModel new
				 allocatorClass: Rectangle;
				 allocatorMethod: Margin >> #asMargin;
				 allocatedObjectClass: Dictionary;
				 sizeInBytes: 16;
				 yourself);
		add: (AllocationSiteInfoModel new
				 allocatorClass: Rectangle;
				 allocatorMethod: Margin >> #asMargin;
				 allocatedObjectClass: ByteString;
				 sizeInBytes: 32;
				 yourself);
		add: (AllocationSiteInfoModel new
				 allocatorClass: Rectangle;
				 allocatorMethod: Margin >> #asMargin;
				 allocatedObjectClass: ByteString;
				 sizeInBytes: 48;
				 yourself);
		add: (AllocationSiteInfoModel new
				 allocatorClass: Rectangle;
				 allocatorMethod: Object >> #'->';
				 allocatedObjectClass: ByteString;
				 sizeInBytes: 100;
				 yourself);
		add: (AllocationSiteInfoModel new
				 allocatorClass: Rectangle;
				 allocatorMethod: Object >> #'->';
				 allocatedObjectClass: ByteString;
				 sizeInBytes: 55;
				 yourself);
		add: (AllocationSiteInfoModel new
				 allocatorClass: Rectangle;
				 allocatorMethod: Object >> #'->';
				 allocatedObjectClass: Color;
				 sizeInBytes: 60;
				 yourself);
		add: (AllocationSiteInfoModel new
				 allocatorClass: Rectangle;
				 allocatorMethod: Object >> #'->';
				 allocatedObjectClass: Color;
				 sizeInBytes: 16;
				 yourself).
	^ allocations
]

{ #category : 'fixture' }
AllocationStatisticsTestFixture >> allocationsThree [

	| allocations |
	allocations := OrderedCollection new.
	allocations add: (AllocationSiteInfoModel new
			 allocatorClass: String;
			 allocatorMethod: Collection>>#sorted:;
			 allocatedObjectClass: ByteArray;
			 sizeInBytes: 16;
			 yourself).
	^ allocations
]

{ #category : 'fixture' }
AllocationStatisticsTestFixture >> allocationsTwo [

	| allocations |
	allocations := OrderedCollection new.
	allocations
		add: (AllocationSiteInfoModel new
				 allocatorClass: OrderedCollection;
				 allocatorMethod: ArrayedCollection >> #add:;
				 allocatedObjectClass: ByteString;
				 sizeInBytes: 16;
				 yourself);
		add: (AllocationSiteInfoModel new
				 allocatorClass: OrderedCollection;
				 allocatorMethod: ArrayedCollection >> #add:;
				 allocatedObjectClass: ByteString;
				 sizeInBytes: 16;
				 yourself);
		add: (AllocationSiteInfoModel new
				 allocatorClass: OrderedCollection;
				 allocatorMethod: ArrayedCollection >> #add:;
				 allocatedObjectClass: ByteString;
				 sizeInBytes: 32;
				 yourself);
		add: (AllocationSiteInfoModel new
				 allocatorClass: OrderedCollection;
				 allocatorMethod: ArrayedCollection >> #add:;
				 allocatedObjectClass: ByteArray;
				 sizeInBytes: 100;
				 yourself);
		add: (AllocationSiteInfoModel new
				 allocatorClass: OrderedCollection;
				 allocatorMethod: ArrayedCollection >> #add:;
				 allocatedObjectClass: ByteArray;
				 sizeInBytes: 16;
				 yourself).
	^ allocations
]

{ #category : 'fixture' }
AllocationStatisticsTestFixture >> groupAndSortByAllocatedObjectClassAllocations: someAllocations [

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
AllocationStatisticsTestFixture >> groupedAndSortedByClassAllocations [

	^ self groupedAndSortedByClassAllocationsOne , self groupedAndSortedByClassAllocationsTwo
	  , self groupedAndSortedByClassAllocationsThree
]

{ #category : 'fixture' }
AllocationStatisticsTestFixture >> groupedAndSortedByClassAllocationsOne [

	^ { (self allocationsOne first allocatorClass
	   -> (self groupAndSortByAllocatedObjectClassAllocations: self allocationsOne)) }
]

{ #category : 'fixture' }
AllocationStatisticsTestFixture >> groupedAndSortedByClassAllocationsThree [

	^ { (self allocationsThree first allocatorClass
	   -> (self groupAndSortByAllocatedObjectClassAllocations: self allocationsThree)) }
]

{ #category : 'fixture' }
AllocationStatisticsTestFixture >> groupedAndSortedByClassAllocationsTwo [

	^ { (self allocationsTwo first allocatorClass
	   -> (self groupAndSortByAllocatedObjectClassAllocations: self allocationsTwo)) }
]

{ #category : 'fixture' }
AllocationStatisticsTestFixture >> groupedAndSortedByMethodAllocations [

	| dict |
	dict := Dictionary new.

	self mockedAllocations do: [ :allo |
		dict
			at: allo fullMethodName
			update: [ :e |
				e
					add: allo;
					yourself ]
			initial: [ OrderedCollection with: allo ] ].

	^ (dict associations sort: [ :a :b | a value size > b value size ]) collect: [ :e |
		  e key -> (self groupAndSortByAllocatedObjectClassAllocations: e value) ]
]

{ #category : 'initialization' }
AllocationStatisticsTestFixture >> initialize [

	super initialize.
	mockedAllocations := self allocationsThree , self allocationsTwo , self allocationsOne.
	groupedAndSortedByClassAllocations := self groupedAndSortedByClassAllocations.
	groupedAndSortedByMethodAllocations := self groupedAndSortedByMethodAllocations
]

{ #category : 'fixture' }
AllocationStatisticsTestFixture >> mockedAllocations [

	^ mockedAllocations
]
