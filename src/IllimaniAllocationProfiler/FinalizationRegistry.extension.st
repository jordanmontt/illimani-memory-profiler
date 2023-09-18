Extension { #name : 'FinalizationRegistry' }

{ #category : '*IllimaniAllocationProfiler' }
FinalizationRegistry >> finalizeAllEphemerons [ 

	| node |
	node := self ephemeronListHead.
	[ node isNotNil ] whileTrue: [
		node value finalize.
		node := node next ]
]
