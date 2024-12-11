Class {
	#name : 'IllAnotherTakeClass',
	#superclass : 'Object',
	#instVars : [
		'aDictionary'
	],
	#category : 'IllimaniProfiler-Experiment-Tests',
	#package : 'IllimaniProfiler-Experiment-Tests'
}

{ #category : 'accessing - token' }
IllAnotherTakeClass >> bar [

	aDictionary at: 1 put: 3
]
