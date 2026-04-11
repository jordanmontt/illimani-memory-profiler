"
An AllocationGraphComponentTest is a test class for testing the behavior of AllocationGraphComponent
"
Class {
	#name : 'AllocationGraphComponentTest',
	#superclass : 'TestCase',
	#instVars : [
		'graphComponent'
	],
	#category : 'AllocationCallGraph-Profiler-Tests-AllocationCallGraph',
	#package : 'AllocationCallGraph-Profiler-Tests',
	#tag : 'AllocationCallGraph'
}

{ #category : 'running' }
AllocationGraphComponentTest >> setUp [

    super setUp.

    graphComponent := AllocationGraphComponent new
]

{ #category : 'tests' }
AllocationGraphComponentTest >> testBeImmortal [

    self deny: graphComponent isImmortal.
    self deny: graphComponent isLongLived.

    graphComponent beImmortal.

    self assert: graphComponent isImmortal.
    self assert: graphComponent isLongLived.
    self deny: graphComponent isShortLived
]

{ #category : 'tests' }
AllocationGraphComponentTest >> testBeLongLived [

	 self deny: graphComponent isImmortal.
    self deny: graphComponent isLongLived.

    graphComponent beLongLived.

    self assert: graphComponent isImmortal.
    self assert: graphComponent isLongLived.
    self deny: graphComponent isShortLived
]

{ #category : 'tests' }
AllocationGraphComponentTest >> testBeShortLived [

    self deny: graphComponent isShortLived.

    graphComponent beShortLived.

    self assert: graphComponent isShortLived.
    self deny: graphComponent isImmortal.
    self deny: graphComponent isLongLived
]
