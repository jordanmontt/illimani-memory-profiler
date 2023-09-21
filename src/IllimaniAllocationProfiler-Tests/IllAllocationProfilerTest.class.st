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
IllAllocationProfilerTest >> testProfileOn [

	illimani
		captureAllObjects;
		profileOn: [ OrderedCollection new.
			OrderedCollection new.
			OrderedCollection new.
			Point new.
			Rectangle new ].

	"Greater because the profiler makes 3 allocations"
	self assert: illimani objectAllocations size > 5
]

{ #category : 'tests' }
IllAllocationProfilerTest >> testProfileOnExample [

	| objectsToCapture |
	objectsToCapture := { ByteString. Array. String. OrderedCollection. ByteArray }.

	illimani
		objectsToCapture: objectsToCapture;
		copyExecutionStack;
		profileOn: [ 1000 timesRepeat: [ IllAllocationProfiler new ] ].
	
	self assert: illimani objectAllocations size > 1000.
	illimani objectAllocations do: [ :alloc |
		self assert: (objectsToCapture includes: alloc allocatedObjectClass).
		"Stack was copied"
		self assert: alloc context class equals: Context ]
]

{ #category : 'tests' }
IllAllocationProfilerTest >> testProfileOnExampleCapturingAll [

	illimani
		captureAllObjects;
		copyExecutionStack;
		profileOn: [ 1000 timesRepeat: [ IllAllocationProfiler new ] ].

	"Take one random allocation to check"
	self assert: illimani objectAllocations last context class equals: Context.

	self assert: illimani objectAllocations size > 1000.
	illimani objectAllocations do: [ :alloc |
		"Stack was copied"
		self assert: alloc context class equals: Context ]
]

{ #category : 'tests' }
IllAllocationProfilerTest >> testProfileOnExampleCapturingAllAndIgnoringClasses [

	| allocatorClassesToIgnore |
	allocatorClassesToIgnore := { ByteString . OrderedCollection . Point . Array }.

	illimani
		captureAllObjects;
		copyExecutionStack;
		objectsToIgnore: allocatorClassesToIgnore;
		profileOn: [ 
			allocatorClassesToIgnore do: [ :aClass | aClass new ].
			1000 timesRepeat: [ IllAllocationProfiler new ] ].

	"Take one random allocation to check"
	self assert: illimani objectAllocations last context class equals: Context.
	
	self assert: illimani objectAllocations size > 1000.
	illimani objectAllocations do: [ :alloc |
		self deny: (allocatorClassesToIgnore includes: alloc allocatedObjectClass).
		"Stack was copied"
		self assert: alloc context class equals: Context ]
]

{ #category : 'tests' }
IllAllocationProfilerTest >> testSamplingRate [

	| allocatedByteSrings |
	illimani
		captureAllObjects;
		samplingRate: 33;
		profileOn: [ 90 timesRepeat: [ ByteString new ] ].

	allocatedByteSrings := (illimani objectAllocations select:
		[ :e | e allocatedObjectClass = ByteString ]) size.

	"We are cheking in this range becase the profiler makes some allocations that are
	necessary for the profiler to work, like Durations objects. So we cannot chack that the
	allocations are exacty 1/3 of the total."
	self assert: (allocatedByteSrings >= 30) & (allocatedByteSrings < 40)
]
