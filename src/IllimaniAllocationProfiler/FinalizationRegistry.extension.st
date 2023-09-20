Extension { #name : 'FinalizationRegistry' }

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
