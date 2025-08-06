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

		"""""""""" "Packages" """"""""""
		"Illimani framework"
		spec package: 'Illimani-FrameworkProfiler'.
		spec package: 'Illimani-FrameworkProfiler-UI' with: [ spec requires: #( 'Illimani-FrameworkProfiler' ) ].
		spec package: 'Illimani-FrameworkProfiler-Examples' with: [ spec requires: #( 'Illimani-FrameworkProfiler' 'Illimani-FrameworkProfiler-UI' ) ].
		spec package: 'Illimani-FrameworkProfiler-Tests' with: [ spec requires: #( 'Illimani-FrameworkProfiler' ) ].
		"Filip profiler"
		spec package: 'FiLiP-MemoryProfiler' with: [ spec requires: #( 'Illimani-FrameworkProfiler' ) ].
		spec package: 'FiLiP-MemoryProfiler-UI' with: [ spec requires: #( 'FiLiP-MemoryProfiler' 'Illimani-FrameworkProfiler-UI' ) ].
		spec package: 'FiLiP-MemoryProfiler-Tests' with: [ spec requires: #( 'FiLiP-MemoryProfiler' ) ].
		spec package: 'FiLiP-MemoryProfiler-UI-Tests' with: [ spec requires: #( 'FiLiP-MemoryProfiler-UI' ) ].
		"Allocation call graph profiler"
		spec package: 'AllocationCallGraph-Profiler' with: [ spec requires: #( 'Illimani-FrameworkProfiler' ) ].
		spec package: 'AllocationCallGraph-Profiler-TestUtilities'.
		spec package: 'AllocationCallGraph-Profiler-Tests' with: [ spec requires: #( 'AllocationCallGraph-Profiler' 'AllocationCallGraph-Profiler-TestUtilities' ) ].
		spec package: 'AllocationCallGraph-Profiler-UI' with: [ spec requires: #( 'AllocationCallGraph-Profiler' ) ].


		"""""""""" "External dependencies """""""""""
		spec baseline: 'NeoJSON' with: [ spec repository: 'github://svenvc/NeoJSON/repository' ].
		spec baseline: 'NeoCSV' with: [ spec repository: 'github://svenvc/NeoCSV/repository' ].
		spec baseline: 'MethodProxies' with: [ spec repository: 'github://pharo-contributions/MethodProxies' ].
		"Link external dependencies"
		spec package: 'Illimani-FrameworkProfiler' with: [ spec requires: #('NeoJSON' 'NeoCSV' 'MethodProxies') ].
		
		
		"""""""""" "Compatibility with older versions of Pharo" """"""""""
		spec for: #(#'pharo10.x' #'pharo11.x' #'pharo12.x') do: [
			spec package: 'Illimani-Pharo12-Compatibility'.
			spec package: 'Illimani-FrameworkProfiler' with: [ spec requires: #( 'Illimani-Pharo12-Compatibility' ) ] ].
		spec for: #(#'pharo10.x' #'pharo11.x') do: [
			spec baseline: 'Roassal' with: [ spec repository: 'github://pharo-graphics/Roassal/src' ].
			spec package: 'FiLiP-MemoryProfiler-UI' with: [ spec requires: #('Roassal') ].
			spec baseline: 'MethodProxies'
				with: [ spec repository: 'github://pharo-contributions/MethodProxies:a3204024eba7fce4f92db7f521425d3d0d869afc/src' ].
			spec package: 'Illimani-FrameworkProfiler' with: [ spec requires: #('MethodProxies') ] ].


		"""""""""" "Groups" """"""""""
		spec group: 'default' with: #( 'core' ).
		spec group: 'core' with: #( 'illimani' 'filip' 'allocationCallGraph' ).
		spec group: 'illimani' with: #( 'Illimani-FrameworkProfiler' 'Illimani-FrameworkProfiler-Examples' 'Illimani-FrameworkProfiler-UI' 'Illimani-FrameworkProfiler-Tests' ).
		spec group: 'filip' with: #( 'illimani' 'FiLiP-MemoryProfiler' 'FiLiP-MemoryProfiler-UI' 'FiLiP-MemoryProfiler-Tests' 'FiLiP-MemoryProfiler-UI-Tests' ) .
		spec group: 'allocationCallGraph' with: #( 'illimani' 'AllocationCallGraph-Profiler' 'AllocationCallGraph-Profiler-UI' 'AllocationCallGraph-Profiler-Tests' 'AllocationCallGraph-Profiler-TestUtilities' ) ].
]
