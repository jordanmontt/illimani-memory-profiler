"
An AllocationStatisticsWalkerTest is a test class for testing the behavior of AllocationStatisticsWalker
"
Class {
	#name : 'StatisticModelTest',
	#superclass : 'TestCase',
	#instVars : [
		'fixture',
		'statsModel'
	],
	#category : 'IllimaniProfiler-Tests-Model-Statistics',
	#package : 'IllimaniProfiler-Tests',
	#tag : 'Model-Statistics'
}

{ #category : 'running' }
StatisticModelTest >> setUp [

	super setUp.
	fixture := AllocationStatisticsTestFixture new.
	statsModel := IllStatisticsModel new
		objectAllocations: fixture mockedAllocations;
		yourself
]

{ #category : 'tests' }
StatisticModelTest >> testAllocationsByMethodMatchesTotalAllocations [

	self
		assert: statsModel allocationsByMethod first totalAllocations
		equals: (fixture groupedAndSortedByMethodAllocators first value sum: [ :e | e value size ]).

	self
		assert: statsModel allocationsByMethod second totalAllocations
		equals: (fixture groupedAndSortedByMethodAllocators second value sum: [ :e | e value size ]).

	self
		assert: statsModel allocationsByMethod third totalAllocations
		equals: (fixture groupedAndSortedByMethodAllocators third value sum: [ :e | e value size ])
]

{ #category : 'tests' }
StatisticModelTest >> testAllocationsByMethodRespectsOrder [

	self
		assert: statsModel allocationsByMethod first allocator
		equals: fixture groupedAndSortedByMethodAllocators first key.

	self
		assert: statsModel allocationsByMethod second allocator
		equals: fixture groupedAndSortedByMethodAllocators second key.

	self
		assert: statsModel allocationsByMethod third allocator
		equals: fixture groupedAndSortedByMethodAllocators third key
]

{ #category : 'tests' }
StatisticModelTest >> testNumberOfMethods [

	self
		assert: statsModel numberOfAllocatorMethods
		equals: fixture groupedAndSortedByMethodAllocators size
]

{ #category : 'tests' }
StatisticModelTest >> testTopNAllocationsByMethod [

	(statsModel topNAllocationsByMethod: 2) with: (fixture groupedAndSortedByMethodAllocators first: 2)
		do: [ :a :b | self assert: a allocator equals: b key ]
]

{ #category : 'tests' }
StatisticModelTest >> testTotalAllocatedMemory [

	self
		assert: statsModel totalAllocatedMemory
		equals: (fixture mockedAllocations sum: [ :e | e sizeInBytes ])
]

{ #category : 'tests' }
StatisticModelTest >> testTotalAllocatedObjects [

	self assert: statsModel totalAllocatedObjects equals: fixture mockedAllocations size
]
