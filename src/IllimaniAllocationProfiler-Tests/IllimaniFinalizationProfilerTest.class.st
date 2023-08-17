Class {
	#name : #IllimaniFinalizationProfilerTest,
	#superclass : #TestCase,
	#instVars : [
		'illimani'
	],
	#category : #'IllimaniAllocationProfiler-Tests-Profiler'
}

{ #category : #running }
IllimaniFinalizationProfilerTest >> setUp [

	super setUp.
	illimani := IllimaniFinalizationProfiler new
]

{ #category : #running }
IllimaniFinalizationProfilerTest >> tearDown [

	illimani forceUninstall.
	illimani := nil.
	super tearDown
]

{ #category : #tests }
IllimaniFinalizationProfilerTest >> testProfileOn [

	illimani
		captureAllObjects;
		profileOn: [ 10 timesRepeat: [ IllimaniFinalizationProfiler new ] ].
	
	"We let the GC run for N times to clean the not referenced objects. Because of the
	implementation of ephemerons, they can have hard references between them so it is
	necessary to run the GC several times  "
	10 timesRepeat: [ Smalltalk garbageCollect ].

	self assert: illimani objectAllocations size > 10
]

{ #category : #tests }
IllimaniFinalizationProfilerTest >> testProfileOnFinalizesCorrectly [

	| timeNow |
	
	timeNow := Time microsecondClockValue.
	
	illimani
		captureAllObjects;
		profileOn: [ 10 timesRepeat: [ IllimaniFinalizationProfiler new ] ].
	
	"We let the GC run for N times to clean the not referenced objects. Because of the
	implementation of ephemerons, they can have hard references between them so it is
	necessary to run the GC several times  "
	10 timesRepeat: [ Smalltalk garbageCollect ].

	illimani objectAllocations do: [ :alloc |
		"Finalization time must be after timeNow variable"
		self assert: alloc finalizationTimestamp > timeNow ]
]

{ #category : #tests }
IllimaniFinalizationProfilerTest >> testSamplingRate [

	| allocatedByteSrings |
	illimani
		captureAllObjects;
		samplingRate: 20;
		profileOn: [ 20 timesRepeat: [ ByteString new ] ].

	"We let the GC run for N times to clean the not referenced objects. Because of the
	implementation of ephemerons, they can have hard references between them so it is
	necessary to run the GC several times  "
	20 timesRepeat: [ Smalltalk garbageCollect ].

	allocatedByteSrings := (illimani objectAllocations select:
		[ :e | e allocatedObjectClass = ByteString ]) size.

	"We are cheking in this range becase the profiler makes some allocations that are
	necessary for the profiler to work, like Durations objects. So we cannot check that the
	allocations are exacty 1/5 of the total."
	self assert: (allocatedByteSrings >= 4) & (allocatedByteSrings < 11)
]
