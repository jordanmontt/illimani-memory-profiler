Class {
	#name : 'IllGlobalFinalizer',
	#superclass : 'Object',
	#instVars : [
		'handler'
	],
	#classVars : [
		'DefaultInstance'
	],
	#category : 'IllimaniFinalizationProfiler',
	#package : 'IllimaniFinalizationProfiler'
}

{ #category : 'accessing' }
IllGlobalFinalizer class >> default [

	^ DefaultInstance ifNil: [ DefaultInstance := self new ]
]

{ #category : 'class initialization' }
IllGlobalFinalizer class >> reset [

	DefaultInstance := self new
]

{ #category : 'finalization' }
IllGlobalFinalizer >> finalize: anObject [

	handler finalize: anObject
]

{ #category : 'finalization' }
IllGlobalFinalizer >> handler: aHandler [

	handler := aHandler
]
