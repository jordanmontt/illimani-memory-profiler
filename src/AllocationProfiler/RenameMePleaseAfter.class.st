Class {
	#name : #RenameMePleaseAfter,
	#superclass : #Object,
	#instVars : [
		'allocations'
	],
	#category : #'AllocationProfiler-Data-Structures'
}

{ #category : #'instance creation' }
RenameMePleaseAfter class >> newFor: allocatedClass [

	^ self new
		increaseAllocationsFor: allocatedClass;
		yourself
]

{ #category : #accessing }
RenameMePleaseAfter >> allocations [
	^ allocations
]

{ #category : #initialization }
RenameMePleaseAfter >> allocationsOf: aClass [

	^ allocations at: aClass ifPresent: [ allocations at: aClass ] ifAbsent: [ 0 ]
]

{ #category : #initialization }
RenameMePleaseAfter >> increaseAllocationsFor: allocatedClass [

	allocations at: allocatedClass
		update: [ :counter | counter + 1 ]
		initial: [ 1 ]
]

{ #category : #initialization }
RenameMePleaseAfter >> initialize [

	super initialize.
	allocations := Dictionary new
]

{ #category : #initialization }
RenameMePleaseAfter >> totalAllocations [

	^ allocations sum: [ :each | each yourself ]
]
