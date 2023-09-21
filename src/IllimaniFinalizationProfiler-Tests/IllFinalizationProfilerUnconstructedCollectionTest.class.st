Class {
	#name : 'IllFinalizationProfilerUnconstructedCollectionTest',
	#superclass : 'TestCase',
	#instVars : [
		'profiler'
	],
	#category : 'IllimaniFinalizationProfiler-Tests-Tests',
	#package : 'IllimaniFinalizationProfiler-Tests',
	#tag : 'Tests'
}

{ #category : 'tests' }
IllFinalizationProfilerUnconstructedCollectionTest >> assertAllocationResult: allocationHolderResult expected: allocationHolderExpected [

	self assert: allocationHolderResult allocatedObjectClass equals: allocationHolderExpected allocatedObjectClass.
	self assert: allocationHolderResult sizeInBytes equals: allocationHolderExpected sizeInBytes.
	self assert: allocationHolderResult finalizationTime > allocationHolderResult initializationTime
]

{ #category : 'running' }
IllFinalizationProfilerUnconstructedCollectionTest >> setUp [

	super setUp.
	profiler := IllFinalizationUnprocessedAllocationsProfiler new
]

{ #category : 'tests' }
IllFinalizationProfilerUnconstructedCollectionTest >> testAfterExecutionWithReceiverArgumentsReturnValue [

	| allocation |
	allocation := Array new.
	profiler registerAllocation: allocation.
	profiler finalize: allocation.
	
	self assert: (profiler unprocessedAllocationsCollection at: 1) equals: allocation identityHash.
	self assert: (profiler unprocessedAllocationsCollection at: 3) equals: allocation sizeInMemory.
	self assert: (profiler unprocessedAllocationsCollection at: 4) equals: allocation class.
	"allocation marker"
	self assert: (profiler unprocessedAllocationsCollection at: 5) equals: -1.
	"finalization"
	self assert: (profiler unprocessedAllocationsCollection at: 6) equals: allocation identityHash.
	"finalization marker"
	self assert: (profiler unprocessedAllocationsCollection at: 8) equals: -2.
	"finalization is after initialization"
	self assert: (profiler unprocessedAllocationsCollection at: 7) > (profiler unprocessedAllocationsCollection at: 2).
]

{ #category : 'tests' }
IllFinalizationProfilerUnconstructedCollectionTest >> testArraysAllocation [

	| allocation time |
	time := Time primUTCMicrosecondsClock.
	allocation := Array new.
	profiler registerAllocation: allocation.
	profiler finalize: allocation.
	
	self assert: (profiler unprocessedAllocationsCollection at: 1) equals: allocation identityHash.
	"allocation time"
	self assert: (profiler unprocessedAllocationsCollection at: 2) > time.
	self assert: (profiler unprocessedAllocationsCollection at: 3) equals: allocation sizeInMemory.
	self assert: (profiler unprocessedAllocationsCollection at: 4) equals: allocation class.
	"allocation marker"
	self assert: (profiler unprocessedAllocationsCollection at: 5) equals: -1.
	
	"finalization"
	self assert: (profiler unprocessedAllocationsCollection at: 6) equals: allocation identityHash.
	self assert: (profiler unprocessedAllocationsCollection at: 7) > time.
	"marker"
	self assert: (profiler unprocessedAllocationsCollection at: 8) equals: -2.
]

{ #category : 'tests' }
IllFinalizationProfilerUnconstructedCollectionTest >> testObjectAllocations [

	| allocation allocationHolderExpected allocationHolderResult |
	allocation := Array new.
	profiler registerAllocation: allocation.
	profiler finalize: allocation.
	
	allocationHolderExpected := BasicAllocationInfoModel new
		allocatedObjectClass: allocation class;
		sizeInBytes: allocation sizeInMemory;
		yourself.
	allocationHolderResult := profiler objectAllocations first.
	
	self assertAllocationResult: allocationHolderResult expected: allocationHolderExpected
]

{ #category : 'tests' }
IllFinalizationProfilerUnconstructedCollectionTest >> testObjectAllocationsTwoObjects [

	| allocation allocationHolderExpected1 allocationHolderExpected2 |
	allocation := Array new.
	profiler registerAllocation: allocation.
	profiler finalize: allocation.
	allocationHolderExpected1 := BasicAllocationInfoModel new
		allocatedObjectClass: allocation class;
		sizeInBytes: allocation sizeInMemory;
		yourself.
	
	allocation := OrderedCollection new.
	profiler registerAllocation: allocation.
	profiler finalize: allocation.
	allocationHolderExpected2 := BasicAllocationInfoModel new
		allocatedObjectClass: allocation class;
		sizeInBytes: allocation sizeInMemory;
		yourself.
	
	self assertAllocationResult: profiler objectAllocations first expected: allocationHolderExpected1.
	self assertAllocationResult: profiler objectAllocations second expected: allocationHolderExpected2.
]

{ #category : 'tests' }
IllFinalizationProfilerUnconstructedCollectionTest >> testObjectAllocationsTwoObjectsTwoArrays [

	| allocation allocationHolderExpected1 allocationHolderExpected2 |
	allocation := Array new.
	profiler registerAllocation: allocation.
	profiler finalize: allocation.
	allocationHolderExpected1 := BasicAllocationInfoModel new
		allocatedObjectClass: allocation class;
		sizeInBytes: allocation sizeInMemory;
		yourself.
	
	allocation := OrderedCollection new.
	profiler registerAllocation: allocation.
	profiler finalize: allocation.
	allocationHolderExpected2 := BasicAllocationInfoModel new
		allocatedObjectClass: allocation class;
		sizeInBytes: allocation sizeInMemory;
		yourself.
	
	self assertAllocationResult: profiler objectAllocations first expected: allocationHolderExpected1.
	self assertAllocationResult: profiler objectAllocations second expected: allocationHolderExpected2.
	
]

{ #category : 'tests' }
IllFinalizationProfilerUnconstructedCollectionTest >> testObjectAllocationsWithTwoArrays [

	| allocation allocationHolderExpected allocationHolderResult |
	allocation := Array new.
	profiler registerAllocation: allocation.
	profiler finalize: allocation.
	
	allocationHolderExpected := BasicAllocationInfoModel new
		allocatedObjectClass: allocation class;
		sizeInBytes: allocation sizeInMemory;
		yourself.
	allocationHolderResult := profiler objectAllocations first.
	
	self assertAllocationResult: allocationHolderResult expected: allocationHolderExpected
]
