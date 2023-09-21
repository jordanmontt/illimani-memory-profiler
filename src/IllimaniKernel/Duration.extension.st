Extension { #name : 'Duration' }

{ #category : '*IllimaniKernel' }
Duration >> asDeciSeconds [


 	^ ((seconds * NanosInSecond) + nanos) // (10 raisedToInteger: 8)
]
