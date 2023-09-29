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

	"First, run several GCs to collect the non referenced objects.
	We need to run some GCs because there can be nested dependencies between Ephemerons."
	"25 timesRepeat: [ Smalltalk garbageCollect ]."
	"Then, force the finalization of the unfinalized Ephemerons"
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
		allocatedObjectClass: anObject class;
		sizeInBytes: anObject sizeInMemory;
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
		500 milliSeconds wait ] ] fork
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
	self forceFinalizationOfObjects
]
