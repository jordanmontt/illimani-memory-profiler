Extension { #name : #FinalizationRegistry }

{ #category : #'*IllimaniAllocationProfiler' }
FinalizationRegistry >> values [

	^ ephemeronCollection collect: [ :e | e value ]
]
