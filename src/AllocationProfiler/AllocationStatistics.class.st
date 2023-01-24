"
I am a basic model for the statistics.
"
Class {
	#name : #AllocationStatistics,
	#superclass : #Object,
	#instVars : [
		'allocations'
	],
	#category : #AllocationProfiler
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

	^ self occurrencesBy: [ :e | e objectClass ]
]

{ #category : #statistics }
AllocationStatistics >> allocationsByMethods [

	^ self occurrencesBy: [ :e | e fullMethodName ]
]

{ #category : #statistics }
AllocationStatistics >> groupedAllocatingClasses [

	| classesWithTheirAllocations topClassesByNumberOfAllocations |
	classesWithTheirAllocations := allocations groupedBy: [ :holder | holder objectClass ].

	topClassesByNumberOfAllocations := classesWithTheirAllocations keys sorted: [ :key1 :key2 |
		(classesWithTheirAllocations at: key1) size > (classesWithTheirAllocations at: key2) size ].

	^ topClassesByNumberOfAllocations collect: [ :each | each -> (classesWithTheirAllocations at: each) ]
]

{ #category : #statistics }
AllocationStatistics >> groupedNAllocatingClasses: n [

	| classesWithTheirAllocations |
	classesWithTheirAllocations := self groupedAllocatingClasses.
	^ classesWithTheirAllocations first: (n min: classesWithTheirAllocations size)
]

{ #category : #statistics }
AllocationStatistics >> numberOfClasses [

	^ (allocations collect: [ :e | e objectClass ]) asSet size
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

{ #category : #statistics }
AllocationStatistics >> timeDifferenceBetweenFirstAndLastAllocation [

	^ allocations ifEmpty: [ nil ] ifNotEmpty: [ allocations last timestamp - allocations first timestamp ]
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
AllocationStatistics >> totalUniqueAllocatedObjects [

	^ (allocations collect: [ :a | a allocatedObject ]) asSet size
]
