Extension { #name : 'FinalizationRegistry' }

{ #category : '*IllimaniAllocationProfiler' }
FinalizationRegistry >> finalizeAllEphemerons [ 

	| node |
	node := ephemeronListHead next.
	[ node isNotNil ] whileTrue: [
		node value finalize.
		node := node next ]
]

{ #category : '*IllimaniAllocationProfiler' }
FinalizationRegistry >> myValues [ 

	| col node |
	col := OrderedCollection new.
	node := ephemeronListHead next.
	[ node isNotNil ] whileTrue: [
		col add: node value.
		node := node next ].
	^ col
]
