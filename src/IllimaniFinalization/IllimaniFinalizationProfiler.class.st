Class {
	#name : #IllimaniFinalizationProfiler,
	#superclass : #Object,
	#traits : 'IllimaniTAllocatorWrapper',
	#classTraits : 'IllimaniTAllocatorWrapper classTrait',
	#instVars : [
		'profilerHandler',
		'gcProcess',
		'finalizationRegistry',
		'previousRegistrySize'
	],
	#category : #IllimaniFinalization
}

{ #category : #api }
IllimaniFinalizationProfiler >> addFinalizationFor: newlyAllocatedObject finalizer: objectFinalizationModel [

	finalizationRegistry add: newlyAllocatedObject finalizer: objectFinalizationModel
]

{ #category : #profiling }
IllimaniFinalizationProfiler >> cleanProfilingData [

	profilerHandler clean
]

{ #category : #profiling }
IllimaniFinalizationProfiler >> forceFinalizationOfObjects [
	"Force finalization of the objects. This is because when an objects will be finalizated,
	the ephemeron puts a strong reference to th object, thus, making it referenced. So we need
	to run recursively the gc until there are no more objects in the finalization Registry.
	The retry is a way to continue running some GC until if the finalization registry never
	reaches 0. This can happen if someone is referencing an object, thus the object will never
	die."

	| retries |
	retries := 0.

	[ retries < 10 and: [ finalizationRegistry isNotEmpty ] ] whileTrue: [
		'entered' traceCr.
		previousRegistrySize := finalizationRegistry size.
		Smalltalk garbageCollect.
		50 milliSecond wait.
		retries := previousRegistrySize = finalizationRegistry size ifTrue: [ retries + 1 ]
			           ifFalse: [ 0 ] ]
]

{ #category : #initialization }
IllimaniFinalizationProfiler >> initialize [

	super initialize.
	finalizationRegistry := FinalizationRegistry new.
	profilerHandler := IllimaniFinalizationHandler new
		                   profiler: self;
		                   yourself.
	self initializeMethodProxies: profilerHandler
]

{ #category : #profiling }
IllimaniFinalizationProfiler >> isProfiling [

	^ gcProcess isNotNil
]

{ #category : #api }
IllimaniFinalizationProfiler >> objectAllocations [

	^ profilerHandler objectAllocations
]

{ #category : #profiling }
IllimaniFinalizationProfiler >> startAndRunGCProcess [

	gcProcess := [
	             [ true ] whileTrue: [
		             300 milliSeconds wait.
		             Smalltalk garbageCollect ] ] newProcess.

	gcProcess resume
]

{ #category : #profiling }
IllimaniFinalizationProfiler >> startProfiling [

	self cleanProfilingData.

	self initializeProfilingBasicStats.

	self installMethodProxies.
	"Run a process that triggers the garbage collector. Using ephemerons we overload the GC
	stress."
	self startAndRunGCProcess
]

{ #category : #profiling }
IllimaniFinalizationProfiler >> stopProfiling [
	
	self uninstallMethodProxies.
	
	self terminateGCProcess.
	self forceFinalizationOfObjects.

	self updateStatsWhenFinishingProfiling
]

{ #category : #profiling }
IllimaniFinalizationProfiler >> terminateGCProcess [

	gcProcess terminate.
	gcProcess := nil
]
