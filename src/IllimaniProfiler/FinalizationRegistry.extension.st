Extension { #name : 'FinalizationRegistry' }

{ #category : '*IllimaniProfiler' }
FinalizationRegistry >> finalizeAllEphemerons [

	| node |
	node := ephemeronListHead next.
	[ node isNotNil ] whileTrue: [
		node value finalize.
		node := node next ]
]
