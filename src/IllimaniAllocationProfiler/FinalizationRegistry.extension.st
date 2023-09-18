Extension { #name : 'FinalizationRegistry' }

{ #category : '*IllimaniAllocationProfiler' }
FinalizationRegistry >> finalizeAllEphemerons [

	self valuesDo: #finalize
]
