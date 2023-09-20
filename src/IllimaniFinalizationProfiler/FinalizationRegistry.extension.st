Extension { #name : 'FinalizationRegistry' }

{ #category : '*IllimaniFinalizationProfiler' }
FinalizationRegistry >> finalizeAllEphemerons [

	| node |
	node := ephemeronListHead next.
	[ node isNotNil ] whileTrue: [
		node value finalize.
		node := node next ]
]
