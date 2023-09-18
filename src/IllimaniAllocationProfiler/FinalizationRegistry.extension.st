Extension { #name : 'FinalizationRegistry' }

{ #category : '*IllimaniAllocationProfiler' }
FinalizationRegistry >> finalizeAllEphemerons [ 

	| node |
	node := self ephemeronListHead.
	[ node isNotNil ] whileTrue: [
		node value finalize.
		node := node next ]
]

{ #category : '*IllimaniAllocationProfiler' }
FinalizationRegistry >> values [

	^ ephemeronCollection collect: [ :e | e value ]
]

{ #category : '*IllimaniAllocationProfiler' }
FinalizationRegistry >> valuesDo: aBlock [

	^ self values do: aBlock
]
