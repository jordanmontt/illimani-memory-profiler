Class {
	#name : 'IllimaniFinalizationRegistry',
	#superclass : 'FinalizationRegistry',
	#category : 'IllimaniFinalizationProfiler',
	#package : 'IllimaniFinalizationProfiler'
}

{ #category : 'profiling' }
IllimaniFinalizationRegistry >> finalizeAllEphemerons [ 

	| node |
	node := ephemeronListHead next.
	[ node isNotNil ] whileTrue: [
		node value finalize: node key.
		node := node next ]
]

{ #category : 'finalization' }
IllimaniFinalizationRegistry >> finalizeEphemeron: anEphemeron [

	self removeEphemeron: anEphemeron.
	errorHandler handleErrorsDuring: [ anEphemeron value finalize: anEphemeron key ]
]
