"
I am a baseline
"
Class {
	#name : #BaselineOfAllocationProfiler,
	#superclass : #BaselineOf,
	#category : #BaselineOfIllimaniAllocationProfiler
}

{ #category : #baselines }
BaselineOfAllocationProfiler >> baseline: spec [

	<baseline>
	spec for: #common do: [
		"Packages"
		spec package: 'IllimaniAllocationProfiler' with: [ spec requires: #( 'MethodProxies' 'SpaceAndTime' ) ].
		spec package: 'IllimaniAllocationProfiler-Tests' with: [ spec requires: #( 'IllimaniAllocationProfiler' ) ].
		spec package: 'IllimaniAllocationProfiler-UI' with: [ spec requires: #( 'IllimaniAllocationProfiler' ) ].

		"External dependencies"
		spec baseline: 'MethodProxies'
			with: [ spec repository: 'github://pharo-contributions/MethodProxies/src' ].
		spec baseline: 'SpaceAndTime'
			with: [ spec repository: 'github://jordanmontt/spaceAndTime/src' ].

		"Pharo 10"
		spec
			for: #'pharo10.x' do: [
				spec
					baseline: 'Roassal3'
					with: [ spec repository: 'github://ObjectProfile/Roassal3:v0.9.9m/src' ].
				spec package: 'IllimaniAllocationProfiler-UI' with: [ spec requires: #('Roassal3') ] ].

		"Groups"
		spec group: 'default' with: #( 'core' 'tests' ).
		spec group: 'core' with: #( 'IllimaniAllocationProfiler' 'IllimaniAllocationProfiler-UI' ).
		spec group: 'tests' with: #( 'IllimaniAllocationProfiler-Tests' ) ]
]
