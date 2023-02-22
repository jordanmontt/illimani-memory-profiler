"
I am a fixture class to mock some allocations
"
Class {
	#name : #AllocationStatisticsTestFixture,
	#superclass : #Object,
	#instVars : [
		'groupedAndSortedByClassAllocations',
		'groupedAndSortedByMethodAllocations',
		'mockedAllocations'
	],
	#category : #'AllocationProfiler-Tests-Statistics-Model'
}

{ #category : #fixture }
AllocationStatisticsTestFixture >> allocationsOne [

	| allocations |
	allocations := OrderedCollection new.
	allocations
		add: (AllocationInfoDTO new
				 allocatorClass: Rectangle;
				 allocatorMethodName: #initializePresenters;
				 timestamp: DateAndTime now;
				 allocatedObjectClass: OrderedCollection;
				 totalSizeInBytes: 16;
				 yourself);
		add: (AllocationInfoDTO new
				 allocatorClass: Rectangle;
				 allocatorMethodName: #initializePresenters;
				 timestamp: DateAndTime now;
				 allocatedObjectClass: OrderedCollection;
				 totalSizeInBytes: 16;
				 yourself);
		add: (AllocationInfoDTO new
				 allocatorClass: Rectangle;
				 allocatorMethodName: #connectPresenters;
				 timestamp: DateAndTime now;
				 allocatedObjectClass: Dictionary;
				 totalSizeInBytes: 16;
				 yourself);
		add: (AllocationInfoDTO new
				 allocatorClass: Rectangle;
				 allocatorMethodName: #connectPresenters;
				 timestamp: DateAndTime now;
				 allocatedObjectClass: ByteString;
				 totalSizeInBytes: 32;
				 yourself);
		add: (AllocationInfoDTO new
				 allocatorClass: Rectangle;
				 allocatorMethodName: #connectPresenters;
				 timestamp: DateAndTime now;
				 allocatedObjectClass: ByteString;
				 totalSizeInBytes: 48;
				 yourself);
		add: (AllocationInfoDTO new
				 allocatorClass: Rectangle;
				 allocatorMethodName: #defaultLayout;
				 timestamp: DateAndTime now;
				 allocatedObjectClass: ByteString;
				 totalSizeInBytes: 100;
				 yourself);
		add: (AllocationInfoDTO new
				 allocatorClass: Rectangle;
				 allocatorMethodName: #defaultLayout;
				 timestamp: DateAndTime now;
				 allocatedObjectClass: ByteString;
				 totalSizeInBytes: 55;
				 yourself);
		add: (AllocationInfoDTO new
				 allocatorClass: Rectangle;
				 allocatorMethodName: #defaultLayout;
				 timestamp: DateAndTime now;
				 allocatedObjectClass: Color;
				 totalSizeInBytes: 60;
				 yourself);
		add: (AllocationInfoDTO new
				 allocatorClass: Rectangle;
				 allocatorMethodName: #defaultLayout;
				 timestamp: DateAndTime now;
				 allocatedObjectClass: Color;
				 totalSizeInBytes: 16;
				 yourself).
	^ allocations
]

{ #category : #fixture }
AllocationStatisticsTestFixture >> allocationsThree [

	| allocations |
	allocations := OrderedCollection new.
	allocations add: (AllocationInfoDTO new
			 allocatorClass: String;
			 allocatorMethodName: #sorted:;
			 timestamp: DateAndTime now;
			 allocatedObjectClass: ByteArray;
			 totalSizeInBytes: 16;
			 yourself).
	^ allocations
]

{ #category : #fixture }
AllocationStatisticsTestFixture >> allocationsTwo [

	| allocations |
	allocations := OrderedCollection new.
	allocations
		add: (AllocationInfoDTO new
				 allocatorClass: OrderedCollection;
				 allocatorMethodName: #add:;
				 timestamp: DateAndTime now;
				 allocatedObjectClass: ByteString;
				 totalSizeInBytes: 16;
				 yourself);
		add: (AllocationInfoDTO new
				 allocatorClass: OrderedCollection;
				 allocatorMethodName: #add:;
				 timestamp: DateAndTime now;
				 allocatedObjectClass: ByteString;
				 totalSizeInBytes: 16;
				 yourself);
		add: (AllocationInfoDTO new
				 allocatorClass: OrderedCollection;
				 allocatorMethodName: #add:;
				 timestamp: DateAndTime now;
				 allocatedObjectClass: ByteString;
				 totalSizeInBytes: 32;
				 yourself);
		add: (AllocationInfoDTO new
				 allocatorClass: OrderedCollection;
				 allocatorMethodName: #add:;
				 timestamp: DateAndTime now;
				 allocatedObjectClass: ByteArray;
				 totalSizeInBytes: 100;
				 yourself);
		add: (AllocationInfoDTO new
				 allocatorClass: OrderedCollection;
				 allocatorMethodName: #add:;
				 timestamp: DateAndTime now;
				 allocatedObjectClass: ByteArray;
				 totalSizeInBytes: 16;
				 yourself).
	^ allocations
]

{ #category : #fixture }
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

{ #category : #fixture }
AllocationStatisticsTestFixture >> groupedAndSortedByClassAllocations [

	^ self groupedAndSortedByClassAllocationsOne , self groupedAndSortedByClassAllocationsTwo
	  , self groupedAndSortedByClassAllocationsThree
]

{ #category : #fixture }
AllocationStatisticsTestFixture >> groupedAndSortedByClassAllocationsOne [

	^ { (self allocationsOne first allocatorClass
	   -> (self groupAndSortByAllocatedObjectClassAllocations: self allocationsOne)) }
]

{ #category : #fixture }
AllocationStatisticsTestFixture >> groupedAndSortedByClassAllocationsThree [

	^ { (self allocationsThree first allocatorClass
	   -> (self groupAndSortByAllocatedObjectClassAllocations: self allocationsThree)) }
]

{ #category : #fixture }
AllocationStatisticsTestFixture >> groupedAndSortedByClassAllocationsTwo [

	^ { (self allocationsTwo first allocatorClass
	   -> (self groupAndSortByAllocatedObjectClassAllocations: self allocationsTwo)) }
]

{ #category : #fixture }
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

{ #category : #initialization }
AllocationStatisticsTestFixture >> initialize [

	super initialize.
	mockedAllocations := self allocationsThree , self allocationsTwo , self allocationsOne.
	groupedAndSortedByClassAllocations := self groupedAndSortedByClassAllocations.
	groupedAndSortedByMethodAllocations := self groupedAndSortedByMethodAllocations
]

{ #category : #fixture }
AllocationStatisticsTestFixture >> mockedAllocations [

	^ mockedAllocations
]
