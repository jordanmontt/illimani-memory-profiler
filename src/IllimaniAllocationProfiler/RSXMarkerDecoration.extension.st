Extension { #name : #RSXMarkerDecoration }

{ #category : #'*IllimaniAllocationProfiler' }
RSXMarkerDecoration >> sumUpTo: ratio [

	self assert: (ratio between: 0 and: 1).
	getRelevantValueBlock := [ :aPlot | | total |
		total := aPlot definedValuesY sum.
		(1 to: aPlot definedValuesY size) detect: [ :i |
			(aPlot definedValuesY first: i) sum >= (ratio * total) ] ]

]
