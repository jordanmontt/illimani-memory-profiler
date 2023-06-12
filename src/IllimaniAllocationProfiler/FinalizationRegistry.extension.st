Extension { #name : #FinalizationRegistry }

{ #category : #'*IllimaniAllocationProfiler' }
FinalizationRegistry >> values [

	^ ephemeronCollection collect: [ :e | e value ]
]

{ #category : #'*IllimaniAllocationProfiler' }
FinalizationRegistry >> valuesDo: aBlock [

	^ self values do: aBlock
]
