Class {
	#name : #IllimaniFinalizationProfiler,
	#superclass : #Object,
	#traits : 'IllimaniTAllocatorWrapper',
	#classTraits : 'IllimaniTAllocatorWrapper classTrait',
	#instVars : [
		'profilerHandler',
		'incrementalGCCount',
		'fullGCCount',
		'totalGCTime',
		'gcProcess',
		'finalizationRegistry',
		'previousRegistrySize'
	],
	#category : #IllimaniFinalization
}

{ #category : #adding }
IllimaniFinalizationProfiler >> addFinalizationFor: newlyAllocatedObject finalizer: objectFinalizationModel [

	finalizationRegistry add: newlyAllocatedObject finalizer: objectFinalizationModel
]

{ #category : #profiling }
IllimaniFinalizationProfiler >> cleanProfilingData [

	profilerHandler clean.
	incrementalGCCount := nil.
	fullGCCount := nil.
	totalGCTime := nil
]

{ #category : #initialization }
IllimaniFinalizationProfiler >> initialize [

	super initialize.
	finalizationRegistry := FinalizationRegistry new.
	profilerHandler := IllimaniFinalizationHandler new
		                   profiler: self;
		                   finalizationRegistry: finalizationRegistry;
		                   yourself.
	self initializeMethodProxies: profilerHandler
]

{ #category : #profiling }
IllimaniFinalizationProfiler >> isProfiling [

	^ gcProcess isNotNil
]

{ #category : #initialization }
IllimaniFinalizationProfiler >> objectAllocations [

	^ profilerHandler objectAllocations
]

{ #category : #profiling }
IllimaniFinalizationProfiler >> startProfiling [

	self cleanProfilingData.

	gcProcess := [
	             [ true ] whileTrue: [
		             300 milliSeconds wait.
		             Smalltalk garbageCollect ] ] newProcess.

	self installMethodProxies.
	gcProcess resume.

	incrementalGCCount := Smalltalk vm incrementalGCCount.
	fullGCCount := Smalltalk vm fullGCCount.
	totalGCTime := Duration milliSeconds: Smalltalk vm totalGCTime
]

{ #category : #profiling }
IllimaniFinalizationProfiler >> stopProfiling [

	| retries |
	self uninstallMethodProxies.
	gcProcess terminate.
	gcProcess := nil.

	"Force finalization of the objects. Don't do it if the references are there is no
	finalization."
	retries := 0.

	[ retries < 10 and: [ finalizationRegistry size > 0 ] ] whileTrue: [
		'entered' traceCr.
		previousRegistrySize := finalizationRegistry size.
		Smalltalk garbageCollect.
		50 milliSecond wait.
		retries := previousRegistrySize = finalizationRegistry size ifTrue: [ retries + 1 ]
			           ifFalse: [ 0 ] ].

	incrementalGCCount := Smalltalk vm incrementalGCCount - incrementalGCCount.
	fullGCCount := Smalltalk vm fullGCCount - fullGCCount.
	totalGCTime := (Duration milliSeconds: Smalltalk vm totalGCTime) - totalGCTime
]
