Class {
	#name : 'IllFinalizationUnprocessedAllocationsProfiler',
	#superclass : 'Object',
	#traits : 'IllTAllocatorWrapper',
	#classTraits : 'IllTAllocatorWrapper classTrait',
	#instVars : [
		'statsModel',
		'handler',
		'finalizationRegistry',
		'samplingCounter',
		'samplingRate',
		'unprocessedAllocationsCollection'
	],
	#category : 'IllimaniFinalizationProfiler-Profiler',
	#package : 'IllimaniFinalizationProfiler',
	#tag : 'Profiler'
}

{ #category : 'profiling' }
IllFinalizationUnprocessedAllocationsProfiler >> finalize: anObject [

	unprocessedAllocationsCollection add: anObject identityHash.
	unprocessedAllocationsCollection add: Time primUTCMicrosecondsClock.
	"marker"
	unprocessedAllocationsCollection add: -2
]

{ #category : 'testing' }
IllFinalizationUnprocessedAllocationsProfiler >> forceFinalizationOfObjects [

	"We force the finalization timestamp for the not yet finalized objects."
	finalizationRegistry finalizeAllEphemerons.
	"Then we stop referencing the finalization registry to not re-finalize the objects."
	finalizationRegistry := IllFinalizationRegistry new
]

{ #category : 'initialization' }
IllFinalizationUnprocessedAllocationsProfiler >> initialize [

	super initialize.
	handler := IllFinalizationMpHandler new
		profiler: self;
		yourself.
	finalizationRegistry := IllFinalizationRegistry new.
	"We want an array big enough to be allocated directly into the old space"
	unprocessedAllocationsCollection := OrderedCollection new: 10000000.
	
	samplingCounter := 0.
	samplingRate := 1.

	self initializeMethodProxies: handler
]

{ #category : 'profiling' }
IllFinalizationUnprocessedAllocationsProfiler >> objectAllocations [

	| allocationsDictionary |
	allocationsDictionary := Dictionary new.
	unprocessedAllocationsCollection doWithIndex: [ :data :index |
		| model |
		data = -1 ifTrue: [
			model := allocationsDictionary at: (unprocessedAllocationsCollection at: index - 4) ifAbsentPut: [ BasicAllocationInfoModel new ].
			self processInitialization: model atIndex: index ].
		data = -2 ifTrue: [
			model := allocationsDictionary at: (unprocessedAllocationsCollection at: index - 2).
			self processFinalization: model atIndex: index ] ].

	^ allocationsDictionary values sorted: [ :a :b | a initializationTime < b initializationTime ]
]

{ #category : 'profiling' }
IllFinalizationUnprocessedAllocationsProfiler >> processFinalization: model atIndex: index [

	model finalizationTime: (unprocessedAllocationsCollection at: index - 1)
]

{ #category : 'profiling' }
IllFinalizationUnprocessedAllocationsProfiler >> processInitialization: model atIndex: index [

	model
		allocatedObjectClass: (unprocessedAllocationsCollection at: index - 1);
		sizeInBytes: (unprocessedAllocationsCollection at: index - 2);
		initializationTime: (unprocessedAllocationsCollection at: index - 3)
]

{ #category : 'profiling' }
IllFinalizationUnprocessedAllocationsProfiler >> registerAllocation: anObject [

	"Sampling"
	"samplingCounter := samplingCounter + 1.
	samplingCounter % samplingRate = 0 ifFalse: [ ^ newlyAllocatedObject ]."

	unprocessedAllocationsCollection add: anObject identityHash.
	unprocessedAllocationsCollection add: Time primUTCMicrosecondsClock.
	unprocessedAllocationsCollection add: anObject sizeInMemory.
	unprocessedAllocationsCollection add: anObject class.
	"marker"
	unprocessedAllocationsCollection add: -1.

	"Finalization"
	finalizationRegistry add: anObject finalizer: self
]

{ #category : 'accessing - statistics' }
IllFinalizationUnprocessedAllocationsProfiler >> stats [

	^ statsModel ifNil: [ statsModel := FinalizationStatsModel on: self objectAllocations ]
]

{ #category : 'profiling' }
IllFinalizationUnprocessedAllocationsProfiler >> stopProfiling [

	self uninstallMethodProxies.
	self forceFinalizationOfObjects.
	self updateStatsWhenFinishingProfiling
]

{ #category : 'accessing' }
IllFinalizationUnprocessedAllocationsProfiler >> unprocessedAllocationsCollection [

	^ unprocessedAllocationsCollection
]
