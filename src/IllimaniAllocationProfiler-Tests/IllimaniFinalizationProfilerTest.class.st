Class {
	#name : 'IllimaniFinalizationProfilerTest',
	#superclass : 'TestCase',
	#instVars : [
		'finalizationProfiler'
	],
	#category : 'IllimaniAllocationProfiler-Tests-Profiler',
	#package : 'IllimaniAllocationProfiler-Tests',
	#tag : 'Profiler'
}

{ #category : 'running' }
IllimaniFinalizationProfilerTest >> setUp [

	super setUp.
	finalizationProfiler := IllimaniFinalizationProfiler new
]

{ #category : 'running' }
IllimaniFinalizationProfilerTest >> tearDown [

	finalizationProfiler forceUninstall.
	finalizationProfiler := nil.
	super tearDown
]

{ #category : 'tests' }
IllimaniFinalizationProfilerTest >> testProfileOn [

	finalizationProfiler profileOn: [ 10 timesRepeat: [ IllimaniFinalizationProfiler new ] ].

	"We let the GC run for N times to clean the not referenced objects. Because of the
	implementation of ephemerons, they can have hard references between them so it is
	necessary to run the GC several times  "
	10 timesRepeat: [ Smalltalk garbageCollect ].

	self assert: finalizationProfiler objectAllocations size > 10
]

{ #category : 'tests' }
IllimaniFinalizationProfilerTest >> testProfileOnFinalizesCorrectly [

	| timeNow |
	
	timeNow := Time microsecondClockValue.
	finalizationProfiler profileOn: [ 10 timesRepeat: [ IllimaniFinalizationProfiler new ] ].
	
	"We let the GC run for N times to clean the not referenced objects. Because of the
	implementation of ephemerons, they can have hard references between them so it is
	necessary to run the GC several times  "
	10 timesRepeat: [ Smalltalk garbageCollect ].
	
	self
		assert: finalizationProfiler objectAllocations size
		equals: (finalizationProfiler objectAllocations select: [ :e | e finalizationTimestamp isNotNil]) size.

	finalizationProfiler objectAllocations do: [ :alloc |
		"Finalization time must be after timeNow variable"
		self assert: alloc finalizationTimestamp > timeNow ]
]

{ #category : 'tests' }
IllimaniFinalizationProfilerTest >> testSamplingRate [

	| allocatedByteSrings |
	finalizationProfiler
		samplingRate: 20;
		profileOn: [ 20 timesRepeat: [ ByteString new ] ].

	"We let the GC run for N times to clean the not referenced objects. Because of the
	implementation of ephemerons, they can have hard references between them so it is
	necessary to run the GC several times  "
	20 timesRepeat: [ Smalltalk garbageCollect ].

	allocatedByteSrings := (finalizationProfiler objectAllocations select:
		[ :e | e allocatedObjectClass = ByteString ]) size.

	"We are cheking in this range becase the profiler makes some allocations that are
	necessary for the profiler to work, like Durations objects. So we cannot check that the
	allocations are exacty 1/5 of the total."
	self assert: allocatedByteSrings < 7
]