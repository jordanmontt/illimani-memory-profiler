Class {
	#name : 'IllFinalizationProfiler',
	#superclass : 'IllAbstractProfiler',
	#instVars : [
		'ephemeronsCollection',
		'statsModel',
		'gcProcess'
	],
	#category : 'IllimaniProfiler-Finalization-Profiler',
	#package : 'IllimaniProfiler',
	#tag : 'Finalization-Profiler'
}

{ #category : 'profiling' }
IllFinalizationProfiler >> forceFinalizationOfObjects [

	ephemeronsCollection do: [ :e | e forceFinalization ]
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
		yourself)
]

{ #category : 'accessing' }
IllFinalizationProfiler >> objectAllocations [

	^ ephemeronsCollection
]

{ #category : 'profiling' }
IllFinalizationProfiler >> startGCProcess [

	gcProcess := [
	[ true ] whileTrue: [
		Smalltalk garbageCollect.
		1000 milliSeconds wait ] ] fork
]

{ #category : 'profiling' }
IllFinalizationProfiler >> startProfiling [

	super startProfiling.
	self startGCProcess
]

{ #category : 'accessing - statistics' }
IllFinalizationProfiler >> stats [

	^ statsModel ifNil: [ statsModel := FinalizationStatsModel on: ephemeronsCollection ]
]

{ #category : 'profiling' }
IllFinalizationProfiler >> stopGCProcess [

	gcProcess terminate
]

{ #category : 'profiling' }
IllFinalizationProfiler >> stopProfiling [

	super stopProfiling.
	self stopGCProcess.
	Smalltalk garbageCollect.
	self forceFinalizationOfObjects
]
