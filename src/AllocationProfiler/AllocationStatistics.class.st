"
I am a basic model for the statistics.
"
Class {
	#name : #AllocationStatistics,
	#superclass : #Object,
	#instVars : [
		'allocations'
	],
	#category : #'AllocationProfiler-Statistics-Model'
}

{ #category : #accessing }
AllocationStatistics class >> allocations: someAllocations [

	^ self new
		allocations: someAllocations;
		yourself
]

{ #category : #accessing }
AllocationStatistics >> allocations [

	^ allocations
]

{ #category : #accessing }
AllocationStatistics >> allocations: aCollection [

	allocations := aCollection
]

{ #category : #statistics }
AllocationStatistics >> allocationsByClasses [

	^ self occurrencesBy: [ :e | e allocatorClass ]
]

{ #category : #statistics }
AllocationStatistics >> allocationsByMethods [

	^ self occurrencesBy: [ :e | e fullMethodName ]
]

{ #category : #statistics }
AllocationStatistics >> groupedAndSortedAllocatingClasses [

	| classesWithTheirAllocations topClassesByNumberOfAllocations |
	classesWithTheirAllocations := allocations groupedBy: [ :holder | holder allocatorClass ].

	topClassesByNumberOfAllocations := classesWithTheirAllocations keys sorted: [ :key1 :key2 |
		(classesWithTheirAllocations at: key1) size > (classesWithTheirAllocations at: key2) size ].

	^ topClassesByNumberOfAllocations collect: [ :each | each -> (classesWithTheirAllocations at: each) ]
]

{ #category : #statistics }
AllocationStatistics >> numberOfClasses [

	^ (allocations collect: [ :e | e allocatorClass ]) asSet size
]

{ #category : #statistics }
AllocationStatistics >> numberOfMethods [

	^ (allocations collect: [ :e | e fullMethodName ]) asSet size
]

{ #category : #computations }
AllocationStatistics >> occurrencesBy: aBlock [

	| sortedAllocatedObjects ocurrences |
	sortedAllocatedObjects := OrderedCollection new.
	ocurrences := Bag newFrom: (allocations collect: aBlock).
	ocurrences doWithOccurrences: [ :key :value | sortedAllocatedObjects add: key -> value ].
	^ sortedAllocatedObjects sorted: [ :a :b | a value > b value ]
]

{ #category : #'statistics - time' }
AllocationStatistics >> timeDifferenceBetweenFirstAndLastAllocation [

	^ allocations last timestamp - allocations first timestamp
]

{ #category : #statistics }
AllocationStatistics >> topAllocatorsWithAllOfTheirAllocations: n [

	| dict |
	dict := Dictionary new.
	allocations do: [ :allocationHolder |
		| allocatedClass |
		allocatedClass := allocationHolder allocatedObjectClass.
		dict at: allocationHolder allocatorClass
			ifPresent: [ :subDictionary | subDictionary increaseAllocationsFor: allocatedClass ]
			ifAbsentPut: [ ClassAllocationsDataStructure newFor: allocatedClass ] ].
	^ (dict associations sorted: [ :a :b |
		   a value totalAllocations > b value totalAllocations ]) first: n
]

{ #category : #statistics }
AllocationStatistics >> topGroupedAndSortedAllocatingClasses: n [

	| classesWithTheirAllocations |
	classesWithTheirAllocations := self groupedAndSortedAllocatingClasses.
	^ classesWithTheirAllocations first: (n min: classesWithTheirAllocations size)
]

{ #category : #statistics }
AllocationStatistics >> topNAllocationsByClasses: n [

	| allocationsOrderedByClass |
	allocationsOrderedByClass := self allocationsByClasses.
	^ allocationsOrderedByClass first: (n min: allocationsOrderedByClass size)
]

{ #category : #statistics }
AllocationStatistics >> topNAllocationsByMethods: n [

	| allocationsOrderedByMethod |
	allocationsOrderedByMethod := self allocationsByMethods.
	^ allocationsOrderedByMethod first: (n min: allocationsOrderedByMethod size)
]

{ #category : #statistics }
AllocationStatistics >> totalAllocatedObjects [

	^ allocations size
]

{ #category : #statistics }
AllocationStatistics >> totalEqualAllocatedObjects [
	"This only makes sense if you kept the allocated objects in the profiler. If not, you will
	end up with a set with nil"

	^ (allocations collect: [ :a | a allocatedObject ]) asSet size
]
