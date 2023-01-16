"
I am a basic model for the statistics. See the presenter that uses me.
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
	#category : #AllocationProfilerPresenters
}

{ #category : #accessing }
ObjectAllocationStats class >> allocations: someAllocations [

	^ self new
		allocations: someAllocations;
		yourself
]

{ #category : #accessing }
ObjectAllocationStats >> calculateNumberOfClasses [

	^ (allocations collect: [ :e | e context methodClass ]) asSet size
]

{ #category : #accessing }
ObjectAllocationStats >> calculateNumberOfMethods [

	^ (allocations collect: [ :e | e context asString ]) asSet size
]

{ #category : #accessing }
ObjectAllocationStats >> calculateTotalAllocatedObjects [

	^ allocations size
]

{ #category : #accessing }
ObjectAllocationStats >> calculateTotalUniqueAllocatedObjects [

	^ (allocations collect: [ :a | a allocatedObject ]) asSet size
]

{ #category : #accessing }
ObjectAllocationStats >> numberOfClasses [

	^ numberOfClasses ifNil: [ numberOfClasses := self calculateNumberOfClasses ]
]

{ #category : #accessing }
ObjectAllocationStats >> numberOfMethods [

	^ numberOfMethods ifNil: [ numberOfMethods := self calculateNumberOfMethods ]
]

{ #category : #accessing }
ObjectAllocationStats >> totalAllocatedObjects [

	^ totalAllocatedObjects ifNil: [ totalAllocatedObjects := self calculateTotalAllocatedObjects ]
]

{ #category : #accessing }
ObjectAllocationStats >> totalUniqueAllocatedObjects [

	^ totalUniqueAllocatedObjects ifNil: [ totalUniqueAllocatedObjects := self calculateTotalUniqueAllocatedObjects ]
]
