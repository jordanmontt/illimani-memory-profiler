Class {
	#name : #IllimaniAllocationProfilerTest,
	#superclass : #TestCase,
	#instVars : [
		'illimani'
	],
	#category : #'IllimaniAllocationProfiler-Tests-Profiler'
}

{ #category : #running }
IllimaniAllocationProfilerTest >> setUp [

	super setUp.
	illimani := IllimaniAllocationProfiler new
]

{ #category : #running }
IllimaniAllocationProfilerTest >> tearDown [

	illimani forceUninstall.
	illimani := nil.
	super tearDown
]

{ #category : #tests }
IllimaniAllocationProfilerTest >> testProfileOn [

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

{ #category : #tests }
IllimaniAllocationProfilerTest >> testProfileOnExample [

	| objectsToCapture |
	objectsToCapture := { ByteString. Array. String. OrderedCollection. ByteArray }.

	illimani
		objectsToCapture: objectsToCapture;
		copyExecutionStack;
		profileOn: [ 1000 timesRepeat: [ IllimaniAllocationProfiler new ] ].
	
	self assert: illimani objectAllocations size > 1000.
	illimani objectAllocations do: [ :alloc |
		self assert: (objectsToCapture includes: alloc allocatedObjectClass).
		"Stack was copied"
		self assert: alloc context class equals: Context ]
]

{ #category : #tests }
IllimaniAllocationProfilerTest >> testProfileOnExampleCapturingAll [

	illimani
		captureAllObjects;
		copyExecutionStack;
		profileOn: [ 1000 timesRepeat: [ IllimaniAllocationProfiler new ] ].

	"Take one random allocation to check"
	self assert: illimani objectAllocations last context class equals: Context.

	self assert: illimani objectAllocations size > 1000.
	illimani objectAllocations do: [ :alloc |
		"Stack was copied"
		self assert: alloc context class equals: Context ]
]

{ #category : #tests }
IllimaniAllocationProfilerTest >> testProfileOnExampleCapturingAllAndIgnoringClasses [

	| allocatorClassesToIgnore |
	allocatorClassesToIgnore := { ByteString . OrderedCollection . Point . Array }.

	illimani
		captureAllObjects;
		copyExecutionStack;
		objectsToIgnore: allocatorClassesToIgnore;
		profileOn: [ 
			allocatorClassesToIgnore do: [ :aClass | aClass new ].
			1000 timesRepeat: [ IllimaniAllocationProfiler new ] ].

	"Take one random allocation to check"
	self assert: illimani objectAllocations last context class equals: Context.
	
	self assert: illimani objectAllocations size > 1000.
	illimani objectAllocations do: [ :alloc |
		self deny: (allocatorClassesToIgnore includes: alloc allocatedObjectClass).
		"Stack was copied"
		self assert: alloc context class equals: Context ]
]

{ #category : #tests }
IllimaniAllocationProfilerTest >> testSamplingRate [

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
	self assert: allocatedByteSrings >= 30 & allocatedByteSrings < 40
]
