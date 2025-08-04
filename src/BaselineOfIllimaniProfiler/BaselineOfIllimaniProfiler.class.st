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
		spec package: 'Illimani-FrameworkProfiler'.
		spec package: 'Illimani-FrameworkProfiler-Examples' with: [ spec requires: #( 'Illimani-FrameworkProfiler' ) ].
		spec package: 'Illimani-FrameworkProfiler-Tests' with: [ spec requires: #( 'Illimani-FrameworkProfiler' ) ].
		
		spec package: 'IllimaniUI' with: [ spec requires: #( 'Illimani-FrameworkProfiler' ) ].
		
		spec package: 'FiLiP-MemoryProfiler' with: [ spec requires: #( 'Illimani-FrameworkProfiler' 'IllimaniUI' ) ].
		spec package: 'FiLiP-MemoryProfiler-Tests' with: [ spec requires: #( 'FiLiP-MemoryProfiler' ) ].
		spec package: 'FiLiP-MemoryProfiler-UI-Tests' with: [ spec requires: #( 'FiLiP-MemoryProfiler' 'IllimaniUI' ) ].


		"External dependencies"
		spec baseline: 'NeoJSON' with: [ spec repository: 'github://svenvc/NeoJSON/repository' ].
		spec baseline: 'NeoCSV' with: [ spec repository: 'github://svenvc/NeoCSV/repository' ].
		spec baseline: 'MethodProxies' with: [ spec repository: 'github://pharo-contributions/MethodProxies' ].
		
		
		"Link external dependencies"
		spec package: 'Illimani-FrameworkProfiler' with: [ spec requires: #('NeoJSON' 'NeoCSV' 'MethodProxies') ].
		
		
		"Compatibility with older versions of Pharp"
		"Loading tenured method that are only present by default on Pharon 13"
		spec for: #(#'pharo10.x' #'pharo11.x' #'pharo12.x') do: [
			spec package: 'Illimani-Pharo12-Compatibility'.
			spec package: 'Illimani-FrameworkProfiler' with: [ spec requires: #( 'Illimani-Pharo12-Compatibility' ) ] ].
		"Load Roassal and a fixed release of MethodProxies for Pharo 10 and 11"
		"Load a fixed version of MethodProxies for Pharo 11 or lower. Note that the latest changes of MethodProxies require Pharo 12 or >"
		spec for: #(#'pharo10.x' #'pharo11.x') do: [
			spec baseline: 'Roassal' with: [ spec repository: 'github://pharo-graphics/Roassal/src' ].
			spec package: 'IllimaniUI' with: [ spec requires: #('Roassal') ].
			spec baseline: 'MethodProxies'
				with: [ spec repository: 'github://pharo-contributions/MethodProxies:a3204024eba7fce4f92db7f521425d3d0d869afc/src' ].
			spec package: 'Illimani-FrameworkProfiler' with: [ spec requires: #('MethodProxies') ] ].


		"Groups"
		spec group: 'default' with: #( 'core' 'tests' ).
		spec group: 'core' with: #( 'Illimani-FrameworkProfiler' 'Illimani-FrameworkProfiler-Examples' 'IllimaniUI' 'FiLiP-MemoryProfiler' ).
		spec group: 'tests' with: #( 'Illimani-FrameworkProfiler-Tests' 'FiLiP-MemoryProfiler-Tests' 'FiLiP-MemoryProfiler-UI-Tests' ) ]
]
