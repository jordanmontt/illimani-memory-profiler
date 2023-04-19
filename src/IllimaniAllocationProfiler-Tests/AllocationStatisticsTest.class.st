"
An AllocationStatisticsWalkerTest is a test class for testing the behavior of AllocationStatisticsWalker
"
Class {
	#name : #AllocationStatisticsTest,
	#superclass : #TestCase,
	#instVars : [
		'fixture',
		'statsModel'
	],
	#category : #'IllimaniAllocationProfiler-Tests-Statistics-Model'
}

{ #category : #running }
AllocationStatisticsTest >> setUp [

	super setUp.
	fixture := AllocationStatisticsTestFixture new.
	statsModel := AllocationStatistics new
		          rawAllocations: fixture mockedAllocations;
		          yourself
]

{ #category : #tests }
AllocationStatisticsTest >> testAllocationsByClassHasExactTheSameObjects [

	| col1 col2 |
	"This test is to see if that created data structure that is used for the stats containts exactly the same allocations as the originals"
	col1 := statsModel allocationsByClass first groupedAllocations flatCollect: #value.
	col2 := fixture groupedAndSortedByClassAllocations first value flatCollect: #value.
	self assertCollection: col2 includesAll: col2
]

{ #category : #tests }
AllocationStatisticsTest >> testAllocationsByClassMatchesTotalAllocations [

	self assert: statsModel allocationsByClass first totalAllocations
		equals:
		(fixture groupedAndSortedByClassAllocations first value sum: [ :e | e value size ]).

	self assert: statsModel allocationsByClass second totalAllocations
		equals:
		(fixture groupedAndSortedByClassAllocations second value sum: [ :e | e value size ]).

	self assert: statsModel allocationsByClass third totalAllocations
		equals:
		(fixture groupedAndSortedByClassAllocations third value sum: [ :e | e value size ])
]

{ #category : #tests }
AllocationStatisticsTest >> testAllocationsByClassRespectsOrder [

	self assert: statsModel allocationsByClass first allocator
		equals: fixture groupedAndSortedByClassAllocations first key.

	self assert: statsModel allocationsByClass second allocator
		equals: fixture groupedAndSortedByClassAllocations second key.

	self assert: statsModel allocationsByClass third allocator
		equals: fixture groupedAndSortedByClassAllocations third key
]

{ #category : #tests }
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

{ #category : #tests }
AllocationStatisticsTest >> testAllocationsByMethodRespectsOrder [

	self assert: statsModel allocationsByMethod first allocator
		equals: fixture groupedAndSortedByMethodAllocations first key.

	self assert: statsModel allocationsByMethod second allocator
		equals: fixture groupedAndSortedByMethodAllocations second key.

	self assert: statsModel allocationsByMethod third allocator
		equals: fixture groupedAndSortedByMethodAllocations third key
]

{ #category : #tests }
AllocationStatisticsTest >> testNumberOfClasses [

	self assert: statsModel numberOfClasses
		equals: fixture groupedAndSortedByClassAllocations size
]

{ #category : #tests }
AllocationStatisticsTest >> testNumberOfMethods [

	self assert: statsModel numberOfMethods
		equals: fixture groupedAndSortedByMethodAllocations size
]

{ #category : #tests }
AllocationStatisticsTest >> testTimeDifferenceBetweenFirstAndLastAllocation [

	self assert: statsModel timeDifferenceBetweenFirstAndLastAllocation
		equals: fixture mockedAllocations last timestamp - fixture mockedAllocations first timestamp
]

{ #category : #tests }
AllocationStatisticsTest >> testTopNAllocationsByClass [

	(statsModel topNAllocationsByClass: 2) with:
		(fixture groupedAndSortedByClassAllocations first: 2)
		do: [ :a :b | self assert: a allocator equals: b key ]
]

{ #category : #tests }
AllocationStatisticsTest >> testTopNAllocationsByMethod [

	(statsModel topNAllocationsByMethod: 2) with:
		(fixture groupedAndSortedByMethodAllocations first: 2)
		do: [ :a :b | self assert: a allocator equals: b key ]
]

{ #category : #tests }
AllocationStatisticsTest >> testTotalAllocatedMemory [

	self assert: statsModel totalAllocatedMemory
		equals: (fixture mockedAllocations sum: [ :e | e totalSizeInBytes ])
]

{ #category : #tests }
AllocationStatisticsTest >> testTotalAllocatedObjects [

	self assert: statsModel totalAllocatedObjects equals: fixture mockedAllocations size
]
