Class {
	#name : 'FinalizationStatsModel',
	#superclass : 'Object',
	#instVars : [
		'objectAllocations'
	],
	#category : 'IllimaniFinalizationProfiler-Profiler',
	#package : 'IllimaniFinalizationProfiler',
	#tag : 'Profiler'
}

{ #category : 'instance creation' }
FinalizationStatsModel class >> on: objectAllocations [

	^ self new
		  objectAllocations: objectAllocations;
		  yourself
]

{ #category : 'accessing' }
FinalizationStatsModel >> objectAllocations [

	^ objectAllocations
]

{ #category : 'accessing' }
FinalizationStatsModel >> objectAllocations: anObject [

	objectAllocations := anObject
]

{ #category : 'statistics - time' }
FinalizationStatsModel >> timeDifferenceBetweenFirstAndLastAllocation [

	^ self objectAllocations last initializationTime - self objectAllocations first initializationTime
]

{ #category : 'accessing' }
FinalizationStatsModel >> totalAllocatedMemory [

	^ self objectAllocations inject: 0 into: [ :sum : elem | sum + elem sizeInBytes ]
]

{ #category : 'accessing' }
FinalizationStatsModel >> totalAllocatedObjects [

	^ self objectAllocations size
]
