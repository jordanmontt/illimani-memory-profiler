"
An IllAnalyzerTest is a test class for testing the behavior of IllAnalyzer
"
Class {
	#name : 'IllAnalyzerTest',
	#superclass : 'TestCase',
	#category : 'IllimaniProfiler-Tests-Analyzer',
	#package : 'IllimaniProfiler-Tests',
	#tag : 'Analyzer'
}

{ #category : 'tests' }
IllAnalyzerTest >> testAnalyzeAllocations [

	| ill |
	ill := IllMemoryProfiler new.
	ill profileOn: [ 15 timesRepeat: [ StPlaygroundPresenter open close ] ].
	IllAnalyzer new analyzeAllocations: ill allocationsStats allocationsByLifetime
]
