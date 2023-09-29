Class {
	#name : 'IllFinalizationUnprocessedAllocationsProfiler',
	#superclass : 'IllAbstractProfiler',
	#instVars : [
		'statsModel',
		'finalizationRegistry',
		'unprocessedFinalizations',
		'unprocessedAllocations'
	],
	#category : 'IllimaniProfiler-Finalization-Profiler',
	#package : 'IllimaniProfiler',
	#tag : 'Finalization-Profiler'
}

{ #category : 'profiling' }
IllFinalizationUnprocessedAllocationsProfiler >> finalize: anObject [

	unprocessedFinalizations add: anObject identityHash.
	unprocessedFinalizations add: Time primUTCMicrosecondsClock.
	"marker"
	unprocessedFinalizations add: -2
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

	finalizationRegistry := IllFinalizationRegistry new.
	"We want an array big enough to be allocated directly into the old space"
	unprocessedAllocations := OrderedCollection new: 6000000.
	unprocessedFinalizations := OrderedCollection new: 4000000
]

{ #category : 'profiling' }
IllFinalizationUnprocessedAllocationsProfiler >> internalRegisterAllocation: anObject [

	unprocessedAllocations add: anObject identityHash.
	unprocessedAllocations add: Time primUTCMicrosecondsClock.
	unprocessedAllocations add: anObject sizeInMemory.
	unprocessedAllocations add: anObject class.
	"marker"
	unprocessedAllocations add: -1.

	"Finalization"
	finalizationRegistry add: anObject finalizer: self
]

{ #category : 'accessing' }
IllFinalizationUnprocessedAllocationsProfiler >> objectAllocations [

	| allocationsDictionary |
	allocationsDictionary := Dictionary new.
	unprocessedAllocations doWithIndex: [ :data :index |
		data = -1 ifTrue: [
			| model |
			model := allocationsDictionary at: (unprocessedAllocations at: index - 4) ifAbsentPut: [ AllocationFinalizationInfoModel new ].
			self processInitialization: model atIndex: index ] ].
	
	unprocessedFinalizations doWithIndex: [ :data :index |
		data = -2 ifTrue: [
			| model |
			model := allocationsDictionary at: (unprocessedFinalizations at: index - 2).
			self processFinalization: model atIndex: index ] ].

	^ allocationsDictionary values sorted: [ :a :b | a initializationTime < b initializationTime ]
]

{ #category : 'profiling' }
IllFinalizationUnprocessedAllocationsProfiler >> processFinalization: model atIndex: index [

	model finalizationTime: (unprocessedFinalizations at: index - 1)
]

{ #category : 'profiling' }
IllFinalizationUnprocessedAllocationsProfiler >> processInitialization: model atIndex: index [

	model
		allocatedObjectClass: (unprocessedAllocations at: index - 1);
		sizeInBytes: (unprocessedAllocations at: index - 2);
		initializationTime: (unprocessedAllocations at: index - 3)
]

{ #category : 'accessing - statistics' }
IllFinalizationUnprocessedAllocationsProfiler >> stats [

	^ statsModel ifNil: [ statsModel := FinalizationStatsModel on: self objectAllocations ]
]

{ #category : 'profiling' }
IllFinalizationUnprocessedAllocationsProfiler >> stopProfiling [

	super stopProfiling.
	self forceFinalizationOfObjects
]

{ #category : 'accessing' }
IllFinalizationUnprocessedAllocationsProfiler >> unprocessedAllocations [

	^ unprocessedAllocations
]

{ #category : 'accessing' }
IllFinalizationUnprocessedAllocationsProfiler >> unprocessedFinalizations [

	^ unprocessedFinalizations
]
