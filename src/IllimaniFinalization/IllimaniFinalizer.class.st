"
I am a finalizer that gest called when my model will be garbage collected. More information in the pharo project proposal page https://github.com/pharo-project/pheps/blob/main/phep-0003.md
"
Class {
	#name : #IllimaniFinalizer,
	#superclass : #Object,
	#instVars : [
		'model'
	],
	#category : #IllimaniFinalization
}

{ #category : #finalization }
IllimaniFinalizer >> finalize [

	model finalizationTimestamp: Time microsecondClockValue
]

{ #category : #finalization }
IllimaniFinalizer >> model: anObject [

	model := anObject
]
