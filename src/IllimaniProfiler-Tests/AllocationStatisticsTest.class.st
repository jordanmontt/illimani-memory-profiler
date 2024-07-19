"
An AllocationStatisticsWalkerTest is a test class for testing the behavior of AllocationStatisticsWalker
"
Class {
	#name : 'AllocationStatisticsTest',
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
AllocationStatisticsTest >> setUp [

	super setUp.
	fixture := AllocationStatisticsTestFixture new.
	statsModel := AllocationsStatsModel new
		          rawAllocations: fixture mockedAllocations;
		          yourself
]

{ #category : 'tests' }
AllocationStatisticsTest >> testAllocationsByMethodMatchesTotalAllocations [

	self assert: statsModel allocationsByMethod first totalAllocations
		equals:
		(fixture groupedAndSortedByMethodAllocations first value sum: [ :e | e value size ]).

	self assert: statsModel allocationsByMethod second totalAllocations
		equals:
		(fixture groupedAndSortedByMethodAllocations second value sum: [ :e | e value size ]).

	self assert: statsModel allocationsByMethod third totalAllocations
		equals:
		(fixture groupedAndSortedByMethodAllocations third value sum: [ :e | e value size ])
]

{ #category : 'tests' }
AllocationStatisticsTest >> testAllocationsByMethodRespectsOrder [

	self assert: statsModel allocationsByMethod first allocator
		equals: fixture groupedAndSortedByMethodAllocations first key.

	self assert: statsModel allocationsByMethod second allocator
		equals: fixture groupedAndSortedByMethodAllocations second key.

	self assert: statsModel allocationsByMethod third allocator
		equals: fixture groupedAndSortedByMethodAllocations third key
]

{ #category : 'tests' }
AllocationStatisticsTest >> testNumberOfClasses [

	self
		assert: statsModel numberOfClasses
		equals: fixture groupedAndSortedByClassAllocations size
]

{ #category : 'tests' }
AllocationStatisticsTest >> testNumberOfMethods [

	self assert: statsModel numberOfMethods
		equals: fixture groupedAndSortedByMethodAllocations size
]

{ #category : 'tests' }
AllocationStatisticsTest >> testTimeDifferenceBetweenFirstAndLastAllocation [

	self assert: statsModel timeDifferenceBetweenFirstAndLastAllocation
		equals: fixture mockedAllocations last initializationTime - fixture mockedAllocations first initializationTime
]

{ #category : 'tests' }
AllocationStatisticsTest >> testTopNAllocationsByMethod [

	(statsModel topNAllocationsByMethod: 2) with:
		(fixture groupedAndSortedByMethodAllocations first: 2)
		do: [ :a :b | self assert: a allocator equals: b key ]
]

{ #category : 'tests' }
AllocationStatisticsTest >> testTotalAllocatedMemory [

	self assert: statsModel totalAllocatedMemory
		equals: (fixture mockedAllocations sum: [ :e | e sizeInBytes ])
]

{ #category : 'tests' }
AllocationStatisticsTest >> testTotalAllocatedObjects [

	self assert: statsModel totalAllocatedObjects equals: fixture mockedAllocations size
]
