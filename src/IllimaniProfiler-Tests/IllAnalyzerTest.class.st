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
IllAnalyzerTest >> testIsObjectImmortal [

	| startTime endTime illEphe analyzer |
	startTime := 10.
	endTime := 110.
	
	analyzer := IllAllocationSiteClassificator new
		endTime: endTime;
		startTime: startTime;
		yourself.

	illEphe := IllEphemeron new
		initializationTime: 30;
		finalizationTime: 70;
		yourself.
	self deny: (analyzer isObjectImmortal: illEphe).
	
	illEphe := IllEphemeron new
		initializationTime: 30;
		finalizationTime: 71;
		yourself.
	self assert: (analyzer isObjectImmortal: illEphe).
	
	illEphe := IllEphemeron new
		initializationTime: 10;
		finalizationTime: 110;
		yourself.
	self assert: (analyzer isObjectImmortal: illEphe).
	
	"Strange case"
	analyzer := IllAllocationSiteClassificator new
		startTime: 0;
		endTime: 17;
		yourself.
	illEphe := IllEphemeron new
		initializationTime: 10;
		finalizationTime: 11;
		yourself.
	self deny: (analyzer isObjectImmortal: illEphe).
]
