Class {
	#name : 'IllFinalizationStatsModel',
	#superclass : 'Object',
	#classTraits : 'IllTAllocatorWrapper classTrait',
	#instVars : [
		'objectAllocations'
	],
	#category : 'IllimaniFinalizationProfiler-Profiler',
	#package : 'IllimaniFinalizationProfiler',
	#tag : 'Profiler'
}

{ #category : 'instance creation' }
IllFinalizationStatsModel class >> on: objectAllocations [

	^ self new
		  objectAllocations: objectAllocations;
		  yourself
]

{ #category : 'accessing' }
IllFinalizationStatsModel >> objectAllocations [

	^ objectAllocations
]

{ #category : 'accessing' }
IllFinalizationStatsModel >> objectAllocations: anObject [

	objectAllocations := anObject
]

{ #category : 'statistics - time' }
IllFinalizationStatsModel >> timeDifferenceBetweenFirstAndLastAllocation [

	^ self objectAllocations last initializationTime - self objectAllocations first initializationTime
]

{ #category : 'accessing' }
IllFinalizationStatsModel >> totalAllocatedMemory [

	^ self objectAllocations inject: 0 into: [ :sum : elem | sum + elem sizeInBytes ]
]

{ #category : 'accessing' }
IllFinalizationStatsModel >> totalAllocatedObjects [

	^ self objectAllocations size
]
