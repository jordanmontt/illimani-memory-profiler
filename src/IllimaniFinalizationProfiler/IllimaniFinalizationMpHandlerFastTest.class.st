Class {
	#name : 'IllimaniFinalizationMpHandlerFastTest',
	#superclass : 'TestCase',
	#instVars : [
		'handler'
	],
	#category : 'IllimaniFinalizationProfiler',
	#package : 'IllimaniFinalizationProfiler'
}

{ #category : 'tests' }
IllimaniFinalizationMpHandlerFastTest >> assertAllocationResult: allocationHolderResult expected: allocationHolderExpected [

	self assert: allocationHolderResult allocatedObjectClass equals: allocationHolderExpected allocatedObjectClass.
	self assert: allocationHolderResult sizeInBytes equals: allocationHolderExpected sizeInBytes.
	self assert: allocationHolderResult finalizationTimestamp > allocationHolderResult initializationTimestamp
]

{ #category : 'running' }
IllimaniFinalizationMpHandlerFastTest >> setUp [

	super setUp.
	handler := IllimaniFinalizationMpHandlerFast new
]

{ #category : 'tests' }
IllimaniFinalizationMpHandlerFastTest >> testAfterExecutionWithReceiverArgumentsReturnValue [

	| allocation |
	allocation := Array new.
	handler afterExecutionWithReceiver: nil arguments: nil  returnValue: allocation.
	handler finalize: allocation.
	
	self assert: (handler currentArray at: 1) equals: allocation identityHash.
	self assert: (handler currentArray at: 3) equals: allocation sizeInMemory.
	self assert: (handler currentArray at: 4) equals: allocation class.
	"allocation marker"
	self assert: (handler currentArray at: 5) equals: -1.
	"finalization"
	self assert: (handler currentArray at: 6) equals: allocation identityHash.
	"finalization marker"
	self assert: (handler currentArray at: 8) equals: -2.
	"finalization is after initialization"
	self assert: (handler currentArray at: 7) > (handler currentArray at: 2).
	
	"current index"
	self assert: handler currentIndex equals: 9
]

{ #category : 'tests' }
IllimaniFinalizationMpHandlerFastTest >> testArraysAllocation [

	| allocation time |
	time := Time primUTCMicrosecondsClock.
	allocation := Array new.
	handler initialArraySize: 5.
	handler afterExecutionWithReceiver: nil arguments: nil  returnValue: allocation.
	handler finalize: allocation.
	
	self assert: (handler currentArray at: 1) equals: allocation identityHash.
	"allocation time"
	self assert: (handler accumulatedArrays first at: 2) > time.
	self assert: (handler accumulatedArrays first at: 3) equals: allocation sizeInMemory.
	self assert: (handler accumulatedArrays first at: 4) equals: allocation class.
	"allocation marker"
	self assert: (handler accumulatedArrays first at: 5) equals: -1.
	
	"finalization"
	self assert: (handler currentArray at: 1) equals: allocation identityHash.
	self assert: (handler currentArray at: 2) > time.
	"marker"
	self assert: (handler currentArray at: 3) equals: -2.

	self assert: handler currentIndex equals: 4
]

{ #category : 'tests' }
IllimaniFinalizationMpHandlerFastTest >> testObjectAllocations [

	| allocation allocationHolderExpected allocationHolderResult |
	allocation := Array new.
	handler afterExecutionWithReceiver: nil arguments: nil  returnValue: allocation.
	handler finalize: allocation.
	
	allocationHolderExpected := BasicAllocationInfoModel new
		allocatedObjectClass: allocation class;
		sizeInBytes: allocation sizeInMemory;
		yourself.
	allocationHolderResult := handler objectAllocations first.
	
	self assertAllocationResult: allocationHolderResult expected: allocationHolderExpected
]

{ #category : 'tests' }
IllimaniFinalizationMpHandlerFastTest >> testObjectAllocationsTwoObjects [

	| allocation allocationHolderExpected1 allocationHolderExpected2 |
	allocation := Array new.
	handler afterExecutionWithReceiver: nil arguments: nil  returnValue: allocation.
	handler finalize: allocation.
	allocationHolderExpected1 := BasicAllocationInfoModel new
		allocatedObjectClass: allocation class;
		sizeInBytes: allocation sizeInMemory;
		yourself.
	
	allocation := OrderedCollection new.
	handler afterExecutionWithReceiver: nil arguments: nil  returnValue: allocation.
	handler finalize: allocation.
	allocationHolderExpected2 := BasicAllocationInfoModel new
		allocatedObjectClass: allocation class;
		sizeInBytes: allocation sizeInMemory;
		yourself.
	
	self assertAllocationResult: handler objectAllocations first expected: allocationHolderExpected1.
	self assertAllocationResult: handler objectAllocations second expected: allocationHolderExpected2.
]

{ #category : 'tests' }
IllimaniFinalizationMpHandlerFastTest >> testObjectAllocationsTwoObjectsTwoArrays [

	| allocation allocationHolderExpected1 allocationHolderExpected2 |
	allocation := Array new.
	handler initialArraySize: 7.
	handler afterExecutionWithReceiver: nil arguments: nil  returnValue: allocation.
	handler finalize: allocation.
	allocationHolderExpected1 := BasicAllocationInfoModel new
		allocatedObjectClass: allocation class;
		sizeInBytes: allocation sizeInMemory;
		yourself.
	
	allocation := OrderedCollection new.
	handler afterExecutionWithReceiver: nil arguments: nil  returnValue: allocation.
	handler finalize: allocation.
	allocationHolderExpected2 := BasicAllocationInfoModel new
		allocatedObjectClass: allocation class;
		sizeInBytes: allocation sizeInMemory;
		yourself.
	
	self assertAllocationResult: handler objectAllocations first expected: allocationHolderExpected1.
	self assertAllocationResult: handler objectAllocations second expected: allocationHolderExpected2.
	
]

{ #category : 'tests' }
IllimaniFinalizationMpHandlerFastTest >> testObjectAllocationsWithTwoArrays [

	| allocation allocationHolderExpected allocationHolderResult |
	allocation := Array new.
	handler initialArraySize: 5.
	handler afterExecutionWithReceiver: nil arguments: nil  returnValue: allocation.
	handler finalize: allocation.
	
	allocationHolderExpected := BasicAllocationInfoModel new
		allocatedObjectClass: allocation class;
		sizeInBytes: allocation sizeInMemory;
		yourself.
	allocationHolderResult := handler objectAllocations first.
	
	self assertAllocationResult: allocationHolderResult expected: allocationHolderExpected
]
