Class {
	#name : 'IllAnotherFakeClass',
	#superclass : 'Object',
	#instVars : [
		'aDictionary'
	],
	#category : 'IllimaniProfiler-Experiment-Tests',
	#package : 'IllimaniProfiler-Experiment-Tests'
}

{ #category : 'accessing - token' }
IllAnotherFakeClass >> bar [

	aDictionary at: 1 put: 3
]

{ #category : 'initialization' }
IllAnotherFakeClass >> initialize [

	super initialize.
	aDictionary := Dictionary new
]
