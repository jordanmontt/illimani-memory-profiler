Class {
	#name : 'IllAbstractProfilerTest',
	#superclass : 'TestCase',
	#instVars : [
		'profiler'
	],
	#category : 'IllimaniProfiler-Tests-Finalization-Profiler',
	#package : 'IllimaniProfiler-Tests',
	#tag : 'Finalization-Profiler'
}

{ #category : 'testing' }
IllAbstractProfilerTest class >> isAbstract [

	^ self = IllAbstractProfilerTest
]

{ #category : 'running' }
IllAbstractProfilerTest >> profilerClass [

	^ self subclassResponsibility
]

{ #category : 'running' }
IllAbstractProfilerTest >> setUp [

	super setUp.
	profiler := self profilerClass new
]

{ #category : 'running' }
IllAbstractProfilerTest >> tearDown [

	profiler forceUninstall.
	profiler := nil.
	super tearDown
]

{ #category : 'tests' }
IllAbstractProfilerTest >> testOpen [
	"This is a smoke test"

	profiler profileOn: [ 5 timesRepeat: [ self profilerClass new ] ].
	profiler open window close
]

{ #category : 'tests' }
IllAbstractProfilerTest >> testProfileOnSimple [

	profiler profileOn: [ 10 timesRepeat: [ IllFinalizationProfiler new ] ].
	self assert: profiler objectAllocations size > 10
]

{ #category : 'tests' }
IllAbstractProfilerTest >> testSamplingRate [

	| allocatedByteSrings |
	
	profiler
		samplingRate: 33 / 100;
		profileOn: [ 100 timesRepeat: [ ByteString new ] ].

	allocatedByteSrings := (profiler objectAllocations select:
		[ :e | e allocatedObjectClass = ByteString ]) size.

	"We are cheking in this range becase the profiler makes some allocations that are
	necessary for the profiler to work, like Durations objects. So we cannot check that the
	allocations are exacty 1/3 of the total."
	self assert: (allocatedByteSrings >= 33) & (allocatedByteSrings < 40)
]

{ #category : 'tests' }
IllAbstractProfilerTest >> testSamplingRate1in1000 [

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
IllAbstractProfilerTest >> testSamplingRateOtherPercentage [

	| allocatedByteSrings |
	
	profiler
		samplingRate: 75 / 100;
		profileOn: [ 100 timesRepeat: [ ByteString new ] ].

	allocatedByteSrings := (profiler objectAllocations select:
		[ :e | e allocatedObjectClass = ByteString ]) size.

	"We are cheking in this range becase the profiler makes some allocations that are
	necessary for the profiler to work, like Durations objects. So we cannot chack that the
	allocations are exacty 1/3 of the total."
	self assert: (allocatedByteSrings >= 75) & (allocatedByteSrings < 80)
]

{ #category : 'tests' }
IllAbstractProfilerTest >> testSamplingRateVariable [

	"By default, do not sample"
	self assert: profiler samplingRate equals: 1.

	"Sample at 20%"
	profiler samplingRate: 20 / 100.
	self assert: profiler samplingRate equals: (20 / 100).

	"Sample at 75%"
	profiler samplingRate: 75 / 100.
	self assert: profiler samplingRate equals: (75 / 100).

	"Do not sample. The same as sampling 100%"
	profiler samplingRate: 1.
	self assert: profiler samplingRate equals: 1.
]
