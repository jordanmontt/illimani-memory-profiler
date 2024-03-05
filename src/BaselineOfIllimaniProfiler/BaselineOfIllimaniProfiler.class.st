"
I am a baseline
"
Class {
	#name : 'BaselineOfIllimaniProfiler',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfIllimaniProfiler',
	#package : 'BaselineOfIllimaniProfiler'
}

{ #category : 'baselines' }
BaselineOfIllimaniProfiler >> baseline: spec [

	<baseline>
	spec for: #common do: [
		"Packages"
		spec package: 'IllimaniUI'
			with: [ spec requires: #( 'IllimaniProfiler' ) ].
		spec package: 'IllimaniProfiler-Tests'
			with: [ spec requires: #( 'IllimaniProfiler' 'IllimaniUI' ) ].

		"External dependencies"

		"Load NeoCSV and NeoJSON to export the data"
		spec baseline: 'NeoJSON' with: [ spec repository: 'github://svenvc/NeoJSON/repository' ].
		spec baseline: 'NeoCSV' with: [ spec repository: 'github://svenvc/NeoCSV/repository' ].
		spec package: 'IllimaniProfiler' with: [ spec requires: #('NeoJSON' 'NeoCSV') ].

		"Load full MethodProxies for Pharo 12. Note that the latest changes of MethodProxies require Pharo 12 version."
		spec for: #'pharo12.x' do: [
			spec baseline: 'MethodProxies'
				with: [ spec repository: 'github://pharo-contributions/MethodProxies' ].
			spec package: 'IllimaniProfiler' with: [ spec requires: #('MethodProxies') ] ].

		"Load Roassal and a fixed release of MethodProxies for Pharo 10 and 11"
		spec for: #(#'pharo10.x' #'pharo11.x') do: [
			spec baseline: 'Roassal' with: [ spec repository: 'github://pharo-graphics/Roassal/src' ].
			spec package: 'IllimaniUI' with: [ spec requires: #('Roassal') ].
			spec baseline: 'MethodProxies'
				with: [ spec repository: 'github://pharo-contributions/MethodProxies:a3204024eba7fce4f92db7f521425d3d0d869afc/src' ].
			spec package: 'IllimaniProfiler' with: [ spec requires: #('MethodProxies') ] ].

		"Groups"
		spec group: 'default' with: #( 'core' 'tests' ).
		spec group: 'core' with: #( 'IllimaniProfiler' 'IllimaniUI' ).
		spec group: 'tests' with: #( 'IllimaniProfiler-Tests' ) ]
]
