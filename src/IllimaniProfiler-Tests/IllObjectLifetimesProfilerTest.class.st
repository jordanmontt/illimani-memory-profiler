Class {
	#name : 'IllObjectLifetimesProfilerTest',
	#superclass : 'IllAbstractProfilerTest',
	#category : 'IllimaniProfiler-Tests-Finalization-Profiler',
	#package : 'IllimaniProfiler-Tests',
	#tag : 'Finalization-Profiler'
}

{ #category : 'running' }
IllObjectLifetimesProfilerTest >> profilerClass [

	^ IllObjectLifetimesProfiler
]

{ #category : 'tests' }
IllObjectLifetimesProfilerTest >> testOpen [
	
	"Increasing the test time. This is due to CI failures. As the profiler pre-allocates a very
	big collection, the GCs take time."
	self timeLimit: 1 minute.

	super testOpen
]

{ #category : 'tests' }
IllObjectLifetimesProfilerTest >> testProfileOn [

	"Increasing the test time. This is due to CI failures. As the profiler pre-allocates a very
	big collection, the GCs take time."
	self timeLimit: 1 minute.

	profiler
		samplingRate: 1;
		profileOn: [ 10 timesRepeat: [ Object new ] ].

	"We let the GC run for N times to clean the not referenced objects. Because of the
	implementation of ephemerons, they can have hard references between them so it is
	necessary to run the GC several times  "
	3 timesRepeat: [ Smalltalk garbageCollect ].

	self assert: profiler objectAllocations size >= 10
]

{ #category : 'tests' }
IllObjectLifetimesProfilerTest >> testProfileOnFinalizesCorrectly [

	| timeNow |
	"Increasing the test time. This is due to CI failures. As the profiler pre-allocates a very
	big collection, the GCs take time."
	self timeLimit: 1 minute.

	timeNow := Time microsecondClockValue.
	profiler profileOn: [ 10 timesRepeat: [ IllObjectLifetimesProfiler new ] ].

	"We let the GC run for N times to clean the not referenced objects. Because of the
	implementation of ephemerons, they can have hard references between them so it is
	necessary to run the GC several times  "
	3 timesRepeat: [ Smalltalk garbageCollect ].

	self assert: profiler objectAllocations size
		equals: (profiler objectAllocations select: [ :e | e finalizationTime isNotNil ]) size.

	profiler objectAllocations do: [ :alloc | "Finalization time must be after timeNow variable"
		self assert: alloc finalizationTime > timeNow ]
]

{ #category : 'tests' }
IllObjectLifetimesProfilerTest >> testProfileOnSimple [

	"Increasing the test time. This is due to CI failures. As the profiler pre-allocates a very
	big collection, the GCs take time."
	self timeLimit: 1 minute.

	super testProfileOnSimple
]
