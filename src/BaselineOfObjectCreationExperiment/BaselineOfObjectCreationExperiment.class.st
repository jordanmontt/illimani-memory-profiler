"
I am a baseline
"
Class {
	#name : #BaselineOfObjectCreationExperiment,
	#superclass : #BaselineOf,
	#category : #BaselineOfObjectCreationExperiment
}

{ #category : #baselines }
BaselineOfObjectCreationExperiment >> baseline: spec [

	<baseline>
	spec for: #common do: [
		"External dependencies"
		spec baseline: 'MethodProxies'
			with: [ spec repository: 'github://pharo-contributions/MethodProxies/src' ].

		spec package: 'MethodProxiesSebas' with: [ spec requires: #( MethodProxies ) ].

		spec group: 'default' with: #( 'MethodProxiesSebas' ) ]
]
