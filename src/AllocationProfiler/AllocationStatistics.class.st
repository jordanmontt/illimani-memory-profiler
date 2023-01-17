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
AllocationStatistics >> allocationsOrderedByClass [

	^ self occurrencesBy: [ :e | e context methodClass ]
]

{ #category : #statistics }
AllocationStatistics >> allocationsOrderedByMethod [

	^ self occurrencesBy: [ :e | e context asString ]
]

{ #category : #statistics }
AllocationStatistics >> calculateTopAllocatingClasses [

	| classesWithTheirAllocations topClassesByNumberOfAllocations |
	classesWithTheirAllocations := allocations groupedBy: [ :holder | holder context methodClass ].

	topClassesByNumberOfAllocations := classesWithTheirAllocations keys sorted: [ :key1 :key2 |
		(classesWithTheirAllocations at: key1) size > (classesWithTheirAllocations at: key2) size ].

	^ topClassesByNumberOfAllocations collect: [ :each | each -> (classesWithTheirAllocations at: each) ]
]

{ #category : #statistics }
AllocationStatistics >> nAllocationsOrderedByClass: n [

	| allocationsOrderedByClass |
	allocationsOrderedByClass := self allocationsOrderedByClass.
	^ allocationsOrderedByClass first: (n min: allocationsOrderedByClass size)
]

{ #category : #statistics }
AllocationStatistics >> nAllocationsOrderedByMethod: n [

	| allocationsOrderedByMethod |
	allocationsOrderedByMethod := self allocationsOrderedByMethod.
	^ allocationsOrderedByMethod first: (n min: allocationsOrderedByMethod size)
]

{ #category : #statistics }
AllocationStatistics >> numberOfClasses [

	^ (allocations collect: [ :e | e context methodClass ]) asSet size
]

{ #category : #statistics }
AllocationStatistics >> numberOfMethods [

	^ (allocations collect: [ :e | e context asString ]) asSet size
]

{ #category : #computations }
AllocationStatistics >> occurrencesBy: aBlock [

	| sortedAllocatedObjects ocurrences |
	sortedAllocatedObjects := OrderedCollection new.
	ocurrences := Bag newFrom: (allocations collect: aBlock).
	ocurrences doWithOccurrences: [ :key :value | sortedAllocatedObjects add: key -> value ].
	^ sortedAllocatedObjects sorted: [ :a :b | a value < b value ]
]

{ #category : #statistics }
AllocationStatistics >> totalAllocatedObjects [

	^ allocations size
]

{ #category : #statistics }
AllocationStatistics >> totalProfiledTime [

	^ allocations ifEmpty: [ nil ] ifNotEmpty: [ allocations last timestamp - allocations first timestamp ]
]

{ #category : #statistics }
AllocationStatistics >> totalUniqueAllocatedObjects [

	^ (allocations collect: [ :a | a allocatedObject ]) asSet size
]
