"
I am a baseline
"
Class {
	#name : #BaselineOfAllocationProfiler,
	#superclass : #BaselineOf,
	#category : #BaselineOfAllocationProfiler
}

{ #category : #baselines }
BaselineOfAllocationProfiler >> baseline: spec [

	<baseline>
	spec for: #common do: [
		"External dependencies"
		spec baseline: 'MethodProxies'
			with: [ spec repository: 'github://pharo-contributions/MethodProxies/src' ].
		spec baseline: 'SpaceAndTime'
			with: [ spec repository: 'github://jordanmontt/spaceAndTime/src' ].
		spec
			baseline: 'Roassal3'
			with: [ 
			spec repository: 'github://ObjectProfile/Roassal3:v0.9.9m/src' ].
		spec package: 'AllocationProfiler' with: [ spec requires: #( 'Roassal3' 'MethodProxies' 'SpaceAndTime' ) ].
		spec package: 'AllocationProfiler-Tests' with: [ spec requires: #( 'AllocationProfiler' ) ].
		spec package: 'AllocationProfiler-UI' with: [ spec requires: #( 'AllocationProfiler' ) ].

		spec group: 'default' with: #( 'AllocationProfiler' 'AllocationProfiler-UI' 'AllocationProfiler-Tests' ) ]
]
