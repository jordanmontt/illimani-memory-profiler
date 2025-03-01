Class {
	#name : 'IllMemoryProfilerTest',
	#superclass : 'TestCase',
	#instVars : [
		'profiler'
	],
	#category : 'IllimaniProfiler-Tests-Finalization-Profiler',
	#package : 'IllimaniProfiler-Tests',
	#tag : 'Finalization-Profiler'
}

{ #category : 'running' }
IllMemoryProfilerTest >> setUp [

	super setUp.
	profiler := IllMemoryProfiler new
]

{ #category : 'running' }
IllMemoryProfilerTest >> tearDown [

	profiler forceUninstall.
	profiler := nil.
	super tearDown
]

{ #category : 'tests' }
IllMemoryProfilerTest >> testProfileOn [

	profiler
		samplingRate: 1;
		profileOn: [ 1000 timesRepeat: [ Object new ] ].

	self assert: profiler objectAllocations size >= 1000
]

{ #category : 'tests' }
IllMemoryProfilerTest >> testProfileOnFinalizesCorrectly [

	| timeNow |

	self timeLimit: 1 minute.

	"The lifetime is calculated in terms of allocated bytes"
	timeNow := Smalltalk vm parameterAt: 34.
	profiler profileOn: [ 10 timesRepeat: [ IllMemoryProfiler new ] ].

	self assert: profiler objectAllocations size
		equals: (profiler objectAllocations select: [ :e | e finalizationTime isNotNil ]) size.

	profiler objectAllocations do: [ :alloc | "Finalization time must be after timeNow variable"
		self assert: alloc finalizationTime > timeNow ]
]

{ #category : 'tests' }
IllMemoryProfilerTest >> testProfileOnSimple [
	"Default sampling rate is 1/100"

	| nAllocations |
	nAllocations := 1000.

	profiler instrumentator: (IllMockInstrumentator onProfiler: profiler).
	profiler profileOn: [ nAllocations timesRepeat: [ Object illNew ] ].

	self assert: profiler objectAllocations size >= 10.
	self assert: profiler objectAllocations size < 15
]

{ #category : 'tests' }
IllMemoryProfilerTest >> testProfileOnSimpleMoreAllocations [

	profiler
		samplingRate: 1;
		profileOn: [ 1000 timesRepeat: [ Object new ] ].

	self assert: profiler objectAllocations size >= 1000.
	profiler objectAllocations do: [ :alloc |
		self assert: alloc allocatedObjectClass isClass ]
]

{ #category : 'tests' }
IllMemoryProfilerTest >> testSamplingRate [

	| allocatedObjects profilerAllocations |

	"The profiler makes some allocations when being installed."
	profilerAllocations := 3.

	profiler
		samplingRate: 33 / 100;
		profileOn: [ 100 timesRepeat: [ Object new ] ].

	allocatedObjects := profiler objectAllocations size - profilerAllocations.

	"We are cheking in this range becase the profiler makes some allocations that are
	necessary for the profiler to work, like Durations objects. So we cannot check that the
	allocations are exacty 1/3 of the total."
	self assert: (allocatedObjects between: 30 and: 33)
]

{ #category : 'tests' }
IllMemoryProfilerTest >> testSamplingRate1in1000 [

	| allocatedByteSrings |

	profiler
		samplingRate: 1/1000;
		profileOn: [ 1000 timesRepeat: [ ByteString new ] ].

	allocatedByteSrings := (profiler objectAllocations select:
		[ :e | e allocatedObjectClass = ByteString ]) size.

	"We are cheking in this range becase the profiler makes some allocations that are
	necessary for the profiler to work, like Durations objects."
	self assert: (allocatedByteSrings >= 1) & (allocatedByteSrings < 4)
]

{ #category : 'tests' }
IllMemoryProfilerTest >> testSamplingRateOtherPercentage [

	| allocatedByteSrings |
	profiler
		samplingRate: 75 / 100;
		profileOn: [ 1000 timesRepeat: [ Object new ] ].

	allocatedByteSrings := (profiler objectAllocations select: [ :e |
		                        e allocatedObjectClass = Object ]) size.

	"We are cheking in this range becase the profiler makes some allocations that are necessary for the profiler to work "
	self assert: allocatedByteSrings >= 750 & (allocatedByteSrings < 800)
]

{ #category : 'tests' }
IllMemoryProfilerTest >> testSamplingRateVariable [

	"By default, do not sample"
	self assert: profiler samplingRate equals: 1/100.

	"Sample at 20%"
	profiler samplingRate: 20 / 100.
	self assert: profiler samplingRate equals: (20 / 100).

	"Sample at 75%"
	profiler samplingRate: 75 / 100.
	self assert: profiler samplingRate equals: (75 / 100).

	"Do not sample. The same as sampling 100%"
	profiler samplingRate: 1.
	self assert: profiler samplingRate equals: 1
]
