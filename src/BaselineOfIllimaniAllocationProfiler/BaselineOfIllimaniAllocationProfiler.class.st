"
I am a baseline
"
Class {
	#name : 'BaselineOfIllimaniAllocationProfiler',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfIllimaniAllocationProfiler',
	#package : 'BaselineOfIllimaniAllocationProfiler'
}

{ #category : 'baselines' }
BaselineOfIllimaniAllocationProfiler >> baseline: spec [

	<baseline>
	spec for: #common do: [
		"Packages"
		spec package: 'IllimaniAllocationProfiler' with: [ spec requires: #( 'MethodProxies') ].
		spec package: 'IllimaniFinalizationProfiler' with: [ spec requires: #( 'IllimaniAllocationProfiler') ].
		spec package: 'IllimaniAllocationProfiler-Tests' with: [ spec requires: #( 'IllimaniAllocationProfiler' ) ].
		spec package: 'IllimaniAllocationProfiler-UI' with: [ spec requires: #( 'IllimaniAllocationProfiler' ) ].

		"External dependencies"
		spec baseline: 'MethodProxies'
			with: [ spec repository: 'github://pharo-contributions/MethodProxies'
				"spec repository: 'github://pharo-contributions/MethodProxies:a3204024eba7fce4f92db7f521425d3d0d869afc/src'" ].
		"Not needed anymore. Leaving it in case it will be needed in the future"
		"spec baseline: 'SpaceAndTime'
			with: [ spec repository: 'github://jordanmontt/spaceAndTime/src' ]."

		"Loading Roassal for Pharo 10"
		spec for: #'pharo10.x' do: [
			spec
				baseline: 'Roassal3'
				with: [ spec repository: 'github://ObjectProfile/Roassal3:v1.01/src' ].
			spec package: 'IllimaniAllocationProfiler-UI' with: [ spec requires: #('Roassal3') ] ].

		"Groups"
		spec group: 'default' with: #( 'core' 'tests' ).
		spec
			group: 'core'
			with: #( 'IllimaniAllocationProfiler' 'IllimaniAllocationProfiler-UI' 'IllimaniFinalizationProfiler').
		spec group: 'tests' with: #( 'IllimaniAllocationProfiler-Tests' ) ]
]
