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
	"Sampling is not enable for the moment"
	self flag: 'Skip'.
	self skip.
	
	profiler
		samplingRate: 33;
		profileOn: [ 90 timesRepeat: [ ByteString new ] ].

	allocatedByteSrings := (profiler objectAllocations select:
		[ :e | e allocatedObjectClass = ByteString ]) size.

	"We are cheking in this range becase the profiler makes some allocations that are
	necessary for the profiler to work, like Durations objects. So we cannot chack that the
	allocations are exacty 1/3 of the total."
	self assert: (allocatedByteSrings >= 30) & (allocatedByteSrings < 40)
]

{ #category : 'tests' }
IllAbstractProfilerTest >> testSamplingRateVariable [

	"By default, do not sample"
	self assert: profiler samplingRate equals: 1.
	
	"Sample at 20%"
	profiler samplingRate: 20.
	"Sample at 20% is the same as sample each 5 allocations"
	self assert: profiler samplingRate equals: 5.
	
	"Do not sample. The same as sampling 100%".
	profiler samplingRate: 100.
	self assert: profiler samplingRate equals: 1.
]
