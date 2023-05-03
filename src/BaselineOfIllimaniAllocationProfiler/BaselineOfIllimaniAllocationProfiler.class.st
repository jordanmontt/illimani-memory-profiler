"
I am a baseline
"
Class {
	#name : #BaselineOfIllimaniAllocationProfiler,
	#superclass : #BaselineOf,
	#category : #BaselineOfIllimaniAllocationProfiler
}

{ #category : #baselines }
BaselineOfIllimaniAllocationProfiler >> baseline: spec [

	<baseline>
	spec for: #common do: [
		"Packages"
		spec package: 'IllimaniAllocationProfiler' with: [ spec requires: #( 'MethodProxies' 'SpaceAndTime' ) ].
		spec package: 'IllimaniAllocationProfiler-Tests' with: [ spec requires: #( 'IllimaniAllocationProfiler' ) ].
		spec package: 'IllimaniAllocationProfiler-UI' with: [ spec requires: #( 'IllimaniAllocationProfiler' ) ].
		spec package: 'IllimaniBenchmarker'.

		"External dependencies"
		spec baseline: 'MethodProxies'
			with: [ spec repository: 'github://pharo-contributions/MethodProxies:a3204024eba7fce4f92db7f521425d3d0d869afc/src' ].
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
		spec group: 'core' with: #( 'IllimaniAllocationProfiler' 'IllimaniAllocationProfiler-UI' 'IllimaniBenchmarker' ).
		spec group: 'tests' with: #( 'IllimaniAllocationProfiler-Tests' ) ]
]
