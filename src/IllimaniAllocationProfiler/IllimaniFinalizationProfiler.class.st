"
I profile the Garbage Collector and provide information about the lifetime of objects.
"
Class {
	#name : #IllimaniFinalizationProfiler,
	#superclass : #Object,
	#traits : 'IllimaniTAllocatorWrapper',
	#classTraits : 'IllimaniTAllocatorWrapper classTrait',
	#instVars : [
		'profilerHandler',
		'gcProcess',
		'finalizationRegistry'
	],
	#category : #'IllimaniAllocationProfiler-Finalization Profiler'
}

{ #category : #api }
IllimaniFinalizationProfiler >> addFinalizationFor: newlyAllocatedObject finalizer: objectFinalizationModel [

	finalizationRegistry add: newlyAllocatedObject finalizer: objectFinalizationModel
]

{ #category : #profiling }
IllimaniFinalizationProfiler >> captureAllObjects [

	profilerHandler captureAllObjects
]

{ #category : #profiling }
IllimaniFinalizationProfiler >> cleanProfilingData [

	profilerHandler clean.
	finalizationRegistry := FinalizationRegistry new
]

{ #category : #profiling }
IllimaniFinalizationProfiler >> forceFinalizationOfObjects [

	"We force the finalization timestamp for the not yet finalized objects."
	finalizationRegistry values do: #finalize.
	"Then we stop referencing the finalization registry to not re-finalize the objects."
	finalizationRegistry := FinalizationRegistry new.

	"We let the GC run for N times to clean the not referenced objects. Because of the
	implementation of ephemerons, they can have hard references between them so it is
	necessary to run the GC several times  "

	[
	20 timesRepeat: [
		Smalltalk garbageCollect.
		30 milliSecond wait ] ] fork
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

{ #category : #initialization }
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
