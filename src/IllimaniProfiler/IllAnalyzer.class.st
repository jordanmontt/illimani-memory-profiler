Class {
	#name : 'IllAnalyzer',
	#superclass : 'Object',
	#category : 'IllimaniProfiler-Analyzer',
	#package : 'IllimaniProfiler',
	#tag : 'Analyzer'
}

{ #category : 'as yet unclassified' }
IllAnalyzer >> analyzeAllocations: allocations [
	"The allocations are grouped and ordered by lifetime"

	allocations first: 10.
	1 halt
]
