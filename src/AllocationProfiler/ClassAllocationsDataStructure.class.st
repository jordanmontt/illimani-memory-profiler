"
I am just a data structure that has a dictionary with the keys being the allocated classes and the values the number of allocations. I am just used by the heatmap. My purpose is just to faciliate the data manipulation made by the heatmap.
"
Class {
	#name : #ClassAllocationsDataStructure,
	#superclass : #Object,
	#instVars : [
		'allocations'
	],
	#category : #'AllocationProfiler-Data-Structures'
}

{ #category : #'instance creation' }
ClassAllocationsDataStructure class >> newFor: allocatedClass [

	^ self new
		increaseAllocationsFor: allocatedClass;
		yourself
]

{ #category : #accessing }
ClassAllocationsDataStructure >> allocations [
	^ allocations
]

{ #category : #initialization }
ClassAllocationsDataStructure >> allocationsOf: aClass [

	^ allocations at: aClass ifAbsent: [ 0 ]
]

{ #category : #initialization }
ClassAllocationsDataStructure >> eachAllocationsTotal [

	^ allocations values
]

{ #category : #initialization }
ClassAllocationsDataStructure >> increaseAllocationsFor: allocatedClass [

	allocations at: allocatedClass
		update: [ :counter | counter + 1 ]
		initial: [ 1 ]
]

{ #category : #initialization }
ClassAllocationsDataStructure >> initialize [

	super initialize.
	allocations := Dictionary new
]

{ #category : #initialization }
ClassAllocationsDataStructure >> totalAllocations [

	^ allocations sum: [ :each | each yourself ]
]
