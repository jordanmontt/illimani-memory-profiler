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
