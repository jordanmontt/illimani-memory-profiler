"
I am a basic model for the statistics.
"
Class {
	#name : #ObjectAllocationStats,
	#superclass : #SpPresenter,
	#instVars : [
		'numberOfClasses',
		'numberOfMethods',
		'totalAllocatedObjects',
		'totalUniqueAllocatedObjects',
		'allocations'
	],
	#category : #AllocationProfiler
}

{ #category : #accessing }
ObjectAllocationStats class >> allocations: someAllocations [

	^ self new
		allocations: someAllocations;
		yourself
]

{ #category : #accessing }
ObjectAllocationStats >> allocations [

	^ allocations
]

{ #category : #accessing }
ObjectAllocationStats >> allocations: aCollection [

	allocations := aCollection
]

{ #category : #statistics }
ObjectAllocationStats >> allocationsOrderedByClass [

	^ self occurrencesBy: [ :e | e context methodClass ]
]

{ #category : #statistics }
ObjectAllocationStats >> allocationsOrderedByMethod [

	^ self occurrencesBy: [ :e | e context asString ]
]

{ #category : #computations }
ObjectAllocationStats >> calculateNumberOfClasses [

	^ (allocations collect: [ :e | e context methodClass ]) asSet size
]

{ #category : #computations }
ObjectAllocationStats >> calculateNumberOfMethods [

	^ (allocations collect: [ :e | e context asString ]) asSet size
]

{ #category : #statistics }
ObjectAllocationStats >> calculateTopAllocatingClasses [

	| classesWithTheirAllocations topClassesByNumberOfAllocations |
	classesWithTheirAllocations := allocations groupedBy: [ :holder | holder context methodClass ].
	
	topClassesByNumberOfAllocations := classesWithTheirAllocations keys sorted: [ :key1 :key2 | 
		(classesWithTheirAllocations at: key1) size > (classesWithTheirAllocations at: key2) size ].
	
	^ topClassesByNumberOfAllocations collect: [ :each | each -> (classesWithTheirAllocations at: each) ]	
]

{ #category : #statistics }
ObjectAllocationStats >> calculateTopNAllocatingClasses: n [

	| classesWithTheirAllocations |
	classesWithTheirAllocations := self calculateTopAllocatingClasses.
	^ classesWithTheirAllocations first: (n min: classesWithTheirAllocations size).
]

{ #category : #computations }
ObjectAllocationStats >> calculateTotalAllocatedObjects [

	^ allocations size
]

{ #category : #computations }
ObjectAllocationStats >> calculateTotalUniqueAllocatedObjects [

	^ (allocations collect: [ :a | a allocatedObject ]) asSet size
]

{ #category : #statistics }
ObjectAllocationStats >> nAllocationsOrderedByClass: n [

	| allocationsOrderedByClass |
	allocationsOrderedByClass := self allocationsOrderedByClass.
	^ allocationsOrderedByClass first: (n min: allocationsOrderedByClass size)
]

{ #category : #statistics }
ObjectAllocationStats >> nAllocationsOrderedByMethod: n [

	| allocationsOrderedByMethod |
	allocationsOrderedByMethod := self allocationsOrderedByMethod.
	^ allocationsOrderedByMethod first: (n min: allocationsOrderedByMethod size)
]

{ #category : #statistics }
ObjectAllocationStats >> numberOfClasses [

	^ numberOfClasses ifNil: [ numberOfClasses := self calculateNumberOfClasses ]
]

{ #category : #statistics }
ObjectAllocationStats >> numberOfMethods [

	^ numberOfMethods ifNil: [ numberOfMethods := self calculateNumberOfMethods ]
]

{ #category : #computations }
ObjectAllocationStats >> occurrencesBy: aBlock [

	| sortedAllocatedObjects ocurrences |
	sortedAllocatedObjects := OrderedCollection new.
	ocurrences := Bag newFrom: (allocations collect: aBlock).
	ocurrences doWithOccurrences: [ :key :value | sortedAllocatedObjects add: key -> value ].
	^ sortedAllocatedObjects sorted: [ :a :b | a value < b value ]
]

{ #category : #statistics }
ObjectAllocationStats >> totalAllocatedObjects [

	^ totalAllocatedObjects ifNil: [ totalAllocatedObjects := self calculateTotalAllocatedObjects ]
]

{ #category : #statistics }
ObjectAllocationStats >> totalProfiledTime [

	^ allocations last timestamp - allocations first timestamp
]

{ #category : #statistics }
ObjectAllocationStats >> totalUniqueAllocatedObjects [

	^ totalUniqueAllocatedObjects ifNil: [ totalUniqueAllocatedObjects := self calculateTotalUniqueAllocatedObjects ]
]
