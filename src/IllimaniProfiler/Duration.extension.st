Extension { #name : 'Duration' }

{ #category : '*IllimaniProfiler' }
Duration >> asDeciSeconds [


 	^ ((seconds * NanosInSecond) + nanos) // (10 raisedToInteger: 8)
]
