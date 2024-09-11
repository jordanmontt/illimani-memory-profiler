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
	self skip.
	ill := IllMemoryProfiler new.
	ill profileOn: [ 15 timesRepeat: [ StPlaygroundPresenter open close ] ].
	IllAnalyzer new analyzeAllocations: ill allocationsStats allocationsByLifetime
]

{ #category : 'tests' }
IllAnalyzerTest >> testIsObjectImmortal [

	| initialTime totalTime illEphe analyzer |
	initialTime := 10.
	totalTime := 110.
	
	illEphe := IllEphemeron new
		initializationTime: 30;
		finalizationTime: 50;
		yourself.
	analyzer := IllAnalyzer new
		totalTime: totalTime;
		initialAllocationTime: initialTime;
		yourself.
	self deny: (analyzer isObjectImmortal: illEphe).
	
	illEphe := IllEphemeron new
		initializationTime: 30;
		finalizationTime: 60;
		yourself.
	self assert: (analyzer isObjectImmortal: illEphe).
	
	illEphe := IllEphemeron new
		initializationTime: 10;
		finalizationTime: 110;
		yourself.
	self assert: (analyzer isObjectImmortal: illEphe).

	illEphe := IllEphemeron new
		initializationTime: 10;
		finalizationTime: 61;
		yourself.
	self assert: (analyzer isObjectImmortal: illEphe)
]

{ #category : 'tests' }
IllAnalyzerTest >> testTimeOfDeathOf [

	| initialTime totalTime illEphe analyzer |
	
	self skip.
	
	initialTime := 10.
	totalTime := 110.
	
	analyzer := IllAnalyzer new
		initialAllocationTime: initialTime;
		totalTime: totalTime;
		yourself.
	illEphe := IllEphemeron new
		finalizationTime: 130;
		yourself.
	self assert: (analyzer timeOfDeathOf: illEphe) equals: 1.
	
	illEphe := IllEphemeron new
		finalizationTime: 100;
		yourself.
	self assert: (analyzer timeOfDeathOf: illEphe) closeTo: 0.9.
	
	illEphe := IllEphemeron new
		finalizationTime: 110;
		yourself.
	self assert: (analyzer timeOfDeathOf: illEphe) closeTo: 1
]

{ #category : 'tests' }
IllAnalyzerTest >> testTimeOfDeathOfNoNormalization [

	| initialTime totalTime illEphe analyzer |
	initialTime := 10.
	totalTime := 110.
	
	analyzer := IllAnalyzer new
		initialAllocationTime: initialTime;
		totalTime: totalTime;
		yourself.
	illEphe := IllEphemeron new
		finalizationTime: 130;
		yourself.
	self assert: (analyzer timeOfDeathOf: illEphe) equals: 110.
	
	illEphe := IllEphemeron new
		finalizationTime: 100;
		yourself.
	self assert: (analyzer timeOfDeathOf: illEphe) closeTo: 90.
	
	illEphe := IllEphemeron new
		finalizationTime: 110;
		yourself.
	self assert: (analyzer timeOfDeathOf: illEphe) closeTo: 100
]
