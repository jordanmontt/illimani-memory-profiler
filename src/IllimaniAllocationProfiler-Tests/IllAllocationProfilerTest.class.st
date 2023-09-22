Class {
	#name : 'IllAllocationProfilerTest',
	#superclass : 'TestCase',
	#instVars : [
		'illimani'
	],
	#category : 'IllimaniAllocationProfiler-Tests-Profiler',
	#package : 'IllimaniAllocationProfiler-Tests',
	#tag : 'Profiler'
}

{ #category : 'running' }
IllAllocationProfilerTest >> setUp [

	super setUp.
	illimani := IllAllocationProfiler new
]

{ #category : 'running' }
IllAllocationProfilerTest >> tearDown [

	illimani forceUninstall.
	illimani := nil.
	super tearDown
]

{ #category : 'tests' }
IllAllocationProfilerTest >> testProfileOnCopyExecutionStack [

	illimani
		copyExecutionStack;
		profileOn: [ 10 timesRepeat: [ IllAllocationProfiler new ] ].

	"Take one random allocation to check"
	self assert: illimani objectAllocations last context class equals: Context.

	self assert: illimani objectAllocations size > 100.
	illimani objectAllocations do: [ :alloc | "Stack was copied"
		self assert: alloc context class equals: Context ]
]

{ #category : 'tests' }
IllAllocationProfilerTest >> testProfileOnSimple [

	illimani profileOn: [
		OrderedCollection new.
		OrderedCollection new.
		OrderedCollection new.
		Point new.
		Rectangle new ].

	"Greater because the profiler makes 3 allocations"
	self assert: illimani objectAllocations size > 5
]

{ #category : 'tests' }
IllAllocationProfilerTest >> testProfileOnSimpleMoreAllocations [

	illimani profileOn: [ 1000 timesRepeat: [ IllAllocationProfiler new ] ].

	self assert: illimani objectAllocations size > 1000.
	illimani objectAllocations do: [ :alloc |
		self assert: alloc allocatedObjectClass isClass.
		"Stack was copied"
		self assert: alloc context class equals: Context ]
]

{ #category : 'tests' }
IllAllocationProfilerTest >> testSamplingRate [

	| allocatedByteSrings |
	illimani
		samplingRate: 33;
		profileOn: [ 90 timesRepeat: [ ByteString new ] ].

	allocatedByteSrings := (illimani objectAllocations select:
		[ :e | e allocatedObjectClass = ByteString ]) size.

	"We are cheking in this range becase the profiler makes some allocations that are
	necessary for the profiler to work, like Durations objects. So we cannot chack that the
	allocations are exacty 1/3 of the total."
	self assert: (allocatedByteSrings >= 30) & (allocatedByteSrings < 40)
]

{ #category : 'tests' }
IllAllocationProfilerTest >> testSamplingRateVariable [

	"By default, do not sample"
	self assert: illimani samplingRate equals: 1.
	
	"Sample at 20%"
	illimani samplingRate: 20.
	"Sample at 20% is the same as sample each 5 allocations"
	self assert: illimani samplingRate equals: 5.
	
	"Do not sample. The same as sampling 100%".
	illimani samplingRate: 100.
	self assert: illimani samplingRate equals: 1.
]
