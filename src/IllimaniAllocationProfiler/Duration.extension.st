Extension { #name : 'Duration' }

{ #category : '*IllimaniAllocationProfiler' }
Duration >> asDeciSeconds [


 	^ ((seconds * NanosInSecond) + nanos) // (10 raisedToInteger: 8)
]
