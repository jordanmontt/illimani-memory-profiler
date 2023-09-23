Class {
	#name : 'IllFinalizationProfiler',
	#superclass : 'IllAbstractProfiler',
	#instVars : [
		'ephemeronsCollection',
		'statsModel'
	],
	#category : 'IllimaniProfiler-Finalization-Profiler',
	#package : 'IllimaniProfiler',
	#tag : 'Finalization-Profiler'
}

{ #category : 'profiling' }
IllFinalizationProfiler >> forceFinalizationOfObjects [

	ephemeronsCollection do: [ :e | e mourn ]
]

{ #category : 'initialization' }
IllFinalizationProfiler >> initialize [

	super initialize.
	ephemeronsCollection := OrderedCollection new: 10000000
]

{ #category : 'profiling' }
IllFinalizationProfiler >> internalRegisterAllocation: anObject [
	
	ephemeronsCollection add: (IllEphemeron newPinned 
		key: anObject value: nil;
		allocatedObjectClass: anObject class;
		sizeInBytes: anObject sizeInMemory;
		yourself)
]

{ #category : 'accessing' }
IllFinalizationProfiler >> objectAllocations [

	^ ephemeronsCollection
]

{ #category : 'accessing - statistics' }
IllFinalizationProfiler >> stats [

	^ statsModel ifNil: [ statsModel := FinalizationStatsModel on: ephemeronsCollection ]
]

{ #category : 'profiling' }
IllFinalizationProfiler >> stopProfiling [

	super stopProfiling.
	self forceFinalizationOfObjects
]