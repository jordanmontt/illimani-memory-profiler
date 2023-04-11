Class {
	#name : #IllimaniAllocationProfilerTest,
	#superclass : #TestCase,
	#instVars : [
		'illimani'
	],
	#category : #'AllocationProfiler-Tests'
}

{ #category : #running }
IllimaniAllocationProfilerTest >> setUp [

	super setUp.
	illimani := IllimaniAllocationProfiler new
]
