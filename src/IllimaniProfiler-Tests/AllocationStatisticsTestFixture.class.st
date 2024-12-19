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
AllocationStatisticsTestFixture class >> allocationsOne [

	| allocations |
	allocations := OrderedCollection new.
	9 timesRepeat: [
		allocations add: (IllEphemeron new
				 key: OrderedCollection new value: nil;
				 allocatorMethod: Margin >> #asMargin;
				 offset: 10;
				 mourn;
				 yourself) ].
	^ allocations
]

{ #category : 'fixture' }
AllocationStatisticsTestFixture class >> allocationsThree [

	| allocations |
	allocations := OrderedCollection new.
	allocations add: (IllEphemeron new
			 allocatorMethod: Collection >> #sorted:;
			 key: ByteArray new value: nil;
			 sizeInBytes: 16;
			 offset: 10;
			 yourself).
	^ allocations
]

{ #category : 'fixture' }
AllocationStatisticsTestFixture class >> allocationsTwo [

	| allocations |
	allocations := OrderedCollection new.
	5 timesRepeat: [
		allocations add: (IllEphemeron new
				 key: ByteString new value: nil;
				 allocatorMethod: ArrayedCollection >> #add:;
				 offset: 10;
				 mourn;
				 yourself) ].
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
	mockedAllocations := self class allocationsThree , self class allocationsTwo , self class allocationsOne.
	groupedAndSortedByMethodAllocations := self groupedAndSortedByMethodAllocators
]

{ #category : 'fixture' }
AllocationStatisticsTestFixture >> mockedAllocations [

	^ mockedAllocations
]
