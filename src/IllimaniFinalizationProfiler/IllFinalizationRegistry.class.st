Class {
	#name : 'IllFinalizationRegistry',
	#superclass : 'FinalizationRegistry',
	#category : 'IllimaniFinalizationProfiler',
	#package : 'IllimaniFinalizationProfiler'
}

{ #category : 'profiling' }
IllFinalizationRegistry >> finalizeAllEphemerons [ 

	| node |
	node := ephemeronListHead next.
	[ node isNotNil ] whileTrue: [
		node value finalize: node key.
		node := node next ]
]

{ #category : 'finalization' }
IllFinalizationRegistry >> finalizeEphemeron: anEphemeron [

	self removeEphemeron: anEphemeron.
	errorHandler handleErrorsDuring: [ anEphemeron value finalize: anEphemeron key ]
]
