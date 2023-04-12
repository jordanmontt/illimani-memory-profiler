Class {
	#name : #IllimaniAllocationProfilerTest,
	#superclass : #TestCase,
	#instVars : [
		'illimani'
	],
	#category : #'AllocationProfiler-Tests-Profiler'
}

{ #category : #running }
IllimaniAllocationProfilerTest >> setUp [

	super setUp.
	illimani := IllimaniAllocationProfiler new
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
IllimaniAllocationProfilerTest >> testProfileOnExampleCapturingAllButMorphic [

	| classesToIgnore |
	classesToIgnore := { ByteString . Array. String . OrderedCollection. ByteArray }.

	illimani
		captureAllObjects;
		copyExecutionStack;
		ignoreAllocators: classesToIgnore;
		profileOn: [ 1000 timesRepeat: [ IllimaniAllocationProfiler new ] ].

	"Take one random allocation to check"
	self assert: illimani objectAllocations last context class equals: Context.
	
	self assert: illimani objectAllocations size > 1000.
	illimani objectAllocations do: [ :alloc |
		self deny: (classesToIgnore includes: alloc allocatorClass).
		"Stack was copied"
		self assert: alloc context class equals: Context ]
]
