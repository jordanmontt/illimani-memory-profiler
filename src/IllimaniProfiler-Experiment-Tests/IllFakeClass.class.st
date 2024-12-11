Class {
	#name : 'IllFakeClass',
	#superclass : 'Object',
	#instVars : [
		'anotherFakeClass'
	],
	#category : 'IllimaniProfiler-Experiment-Tests',
	#package : 'IllimaniProfiler-Experiment-Tests'
}

{ #category : 'accessing' }
IllFakeClass >> foo [

	anotherFakeClass := IllAnotherTakeClass new.
	anotherFakeClass bar
]
