Class {
	#name : 'IllimaniGlobalFinalizer',
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
IllimaniGlobalFinalizer class >> default [

	^ DefaultInstance ifNil: [ DefaultInstance := self new ]
]

{ #category : 'class initialization' }
IllimaniGlobalFinalizer class >> reset [

	DefaultInstance := self new
]

{ #category : 'finalization' }
IllimaniGlobalFinalizer >> finalize: anObject [

	handler finalize: anObject identityHash
]

{ #category : 'finalization' }
IllimaniGlobalFinalizer >> handler: aHandler [

	handler := aHandler
]
