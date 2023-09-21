Class {
	#name : 'IllFinalizationMpHandlerFastTest',
	#superclass : 'TestCase',
	#instVars : [
		'handler'
	],
	#category : 'IllimaniFinalizationProfiler',
	#package : 'IllimaniFinalizationProfiler'
}

{ #category : 'tests' }
IllFinalizationMpHandlerFastTest >> assertAllocationResult: allocationHolderResult expected: allocationHolderExpected [

	self assert: allocationHolderResult allocatedObjectClass equals: allocationHolderExpected allocatedObjectClass.
	self assert: allocationHolderResult sizeInBytes equals: allocationHolderExpected sizeInBytes.
	self assert: allocationHolderResult finalizationTimestamp > allocationHolderResult initializationTimestamp
]

{ #category : 'running' }
IllFinalizationMpHandlerFastTest >> setUp [

	super setUp.
	handler := IllFinalizationMpHandlerFast new
]

{ #category : 'tests' }
IllFinalizationMpHandlerFastTest >> testAfterExecutionWithReceiverArgumentsReturnValue [

	| allocation |
	allocation := Array new.
	handler afterExecutionWithReceiver: nil arguments: nil  returnValue: allocation.
	handler finalize: allocation.
	
	self assert: (handler allocationsUnconstructedCollection at: 1) equals: allocation identityHash.
	self assert: (handler allocationsUnconstructedCollection at: 3) equals: allocation sizeInMemory.
	self assert: (handler allocationsUnconstructedCollection at: 4) equals: allocation class.
	"allocation marker"
	self assert: (handler allocationsUnconstructedCollection at: 5) equals: -1.
	"finalization"
	self assert: (handler allocationsUnconstructedCollection at: 6) equals: allocation identityHash.
	"finalization marker"
	self assert: (handler allocationsUnconstructedCollection at: 8) equals: -2.
	"finalization is after initialization"
	self assert: (handler allocationsUnconstructedCollection at: 7) > (handler allocationsUnconstructedCollection at: 2).
]

{ #category : 'tests' }
IllFinalizationMpHandlerFastTest >> testArraysAllocation [

	| allocation time |
	time := Time primUTCMicrosecondsClock.
	allocation := Array new.
	handler afterExecutionWithReceiver: nil arguments: nil  returnValue: allocation.
	handler finalize: allocation.
	
	self assert: (handler allocationsUnconstructedCollection at: 1) equals: allocation identityHash.
	"allocation time"
	self assert: (handler allocationsUnconstructedCollection at: 2) > time.
	self assert: (handler allocationsUnconstructedCollection at: 3) equals: allocation sizeInMemory.
	self assert: (handler allocationsUnconstructedCollection at: 4) equals: allocation class.
	"allocation marker"
	self assert: (handler allocationsUnconstructedCollection at: 5) equals: -1.
	
	"finalization"
	self assert: (handler allocationsUnconstructedCollection at: 6) equals: allocation identityHash.
	self assert: (handler allocationsUnconstructedCollection at: 7) > time.
	"marker"
	self assert: (handler allocationsUnconstructedCollection at: 8) equals: -2.
]

{ #category : 'tests' }
IllFinalizationMpHandlerFastTest >> testObjectAllocations [

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
IllFinalizationMpHandlerFastTest >> testObjectAllocationsTwoObjects [

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
IllFinalizationMpHandlerFastTest >> testObjectAllocationsTwoObjectsTwoArrays [

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
IllFinalizationMpHandlerFastTest >> testObjectAllocationsWithTwoArrays [

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
