Class {
	#name : 'IllFinalizationProfilerUnconstructedCollection',
	#superclass : 'Object',
	#traits : 'IllTAllocatorWrapper',
	#classTraits : 'IllTAllocatorWrapper classTrait',
	#instVars : [
		'statsModel',
		'handler',
		'finalizationRegistry',
		'allocationsUnconstructedCollection'
	],
	#category : 'IllimaniFinalizationProfiler-Speedup-Experimental',
	#package : 'IllimaniFinalizationProfiler',
	#tag : 'Speedup-Experimental'
}

{ #category : 'accessing' }
IllFinalizationProfilerUnconstructedCollection >> allocationsUnconstructedCollection [
	^ allocationsUnconstructedCollection
]

{ #category : 'profiling' }
IllFinalizationProfilerUnconstructedCollection >> finalize: anObject [

	allocationsUnconstructedCollection add: anObject identityHash.
	allocationsUnconstructedCollection add: Time primUTCMicrosecondsClock.
	"marker"
	allocationsUnconstructedCollection add: -2
]

{ #category : 'testing' }
IllFinalizationProfilerUnconstructedCollection >> forceFinalizationOfObjects [

	"We force the finalization timestamp for the not yet finalized objects."
	finalizationRegistry finalizeAllEphemerons.
	"Then we stop referencing the finalization registry to not re-finalize the objects."
	finalizationRegistry := IllFinalizationRegistry new
]

{ #category : 'initialization' }
IllFinalizationProfilerUnconstructedCollection >> initialize [

	super initialize.
	handler := IllFinalizationMpHandlerUnconstructedCollection new
		profiler: self;
		yourself.
	finalizationRegistry := IllFinalizationRegistry new.
	"We want an array big enough to be allocated directly into the old space"
	allocationsUnconstructedCollection := OrderedCollection new: 10000000.

	self initializeMethodProxies: handler
]

{ #category : 'profiling' }
IllFinalizationProfilerUnconstructedCollection >> objectAllocations [

	| allocationsDictionary |
	allocationsDictionary := Dictionary new.
	allocationsUnconstructedCollection doWithIndex: [ :data :index |
		| model |
		data = -1 ifTrue: [
			model := allocationsDictionary at: (allocationsUnconstructedCollection at: index - 4) ifAbsentPut: [ BasicAllocationInfoModel new ].
			self processInitialization: model atIndex: index ].
		data = -2 ifTrue: [
			model := allocationsDictionary at: (allocationsUnconstructedCollection at: index - 2).
			self processFinalization: model atIndex: index ] ].

	^ allocationsDictionary values sorted: [ :a :b | a initializationTime < b initializationTime ]
]

{ #category : 'profiling' }
IllFinalizationProfilerUnconstructedCollection >> processFinalization: model atIndex: index [

	model finalizationTime: (allocationsUnconstructedCollection at: index - 1)
]

{ #category : 'profiling' }
IllFinalizationProfilerUnconstructedCollection >> processInitialization: model atIndex: index [

	model
		allocatedObjectClass: (allocationsUnconstructedCollection at: index - 1);
		sizeInBytes: (allocationsUnconstructedCollection at: index - 2);
		initializationTime: (allocationsUnconstructedCollection at: index - 3)
]

{ #category : 'profiling' }
IllFinalizationProfilerUnconstructedCollection >> registerAllocation: anObject [

	allocationsUnconstructedCollection add: anObject identityHash.
	allocationsUnconstructedCollection add: Time primUTCMicrosecondsClock.
	allocationsUnconstructedCollection add: anObject sizeInMemory.
	allocationsUnconstructedCollection add: anObject class.
	"marker"
	allocationsUnconstructedCollection add: -1.

	"Finalization"
	finalizationRegistry add: anObject finalizer: self
]

{ #category : 'accessing - statistics' }
IllFinalizationProfilerUnconstructedCollection >> stats [

	^ statsModel ifNil: [ statsModel := FinalizationStatsModel on: self objectAllocations ]
]

{ #category : 'profiling' }
IllFinalizationProfilerUnconstructedCollection >> stopProfiling [

	self uninstallMethodProxies.
	self forceFinalizationOfObjects.
	self updateStatsWhenFinishingProfiling
]
