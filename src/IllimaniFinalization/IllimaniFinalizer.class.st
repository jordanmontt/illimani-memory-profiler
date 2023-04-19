Class {
	#name : #IllimaniFinalizer,
	#superclass : #Object,
	#instVars : [
		'dto'
	],
	#category : #IllimaniFinalization
}

{ #category : #finalization }
IllimaniFinalizer >> dto: obj [

	dto := obj
]

{ #category : #finalization }
IllimaniFinalizer >> finalize [

	dto finalizationTimestamp: Time microsecondClockValue
]
