"
An IllFinalizationExporterTest is a test class for testing the behavior of IllFinalizationExporter
"
Class {
	#name : 'IllFinalizationExporterTest',
	#superclass : 'IllAbstractExporterTest',
	#category : 'IllimaniProfiler-Tests-Exporters',
	#package : 'IllimaniProfiler-Tests',
	#tag : 'Exporters'
}

{ #category : 'asserting' }
IllFinalizationExporterTest >> assertCSVContent: csvReader [

	| line |
	line := csvReader next.
	self assert: line first asInteger > 100000000.
	self assert: line second asInteger equals: 100. "size"
	self assert: (line fourth asClassInEnvironment: Smalltalk globals) isClass.
	self assert: line last equals: 'false'
]

{ #category : 'tests' }
IllFinalizationExporterTest >> expectedCSVHeader [

	^ #( 'finalizationTimeInMicroSeconds' 'sizeInBytes' 'initializationTimeInMicroSeconds'
	     'allocatedObjectClass' 'survivedScavenges' 'survivedFullGCs' 'forcedFinalization' )
]

{ #category : 'exporting' }
IllFinalizationExporterTest >> exporterClass [

	^ IllFinalizationExporter
]

{ #category : 'running' }
IllFinalizationExporterTest >> fakeAllocations [

	| allocatedClasses |
	allocatedClasses := 'Kernel' asPackage definedClasses asArray first: 10.
	^ (1 to: 1000) collect: [ :i | IllEphemeron new
		allocatedObjectClass: allocatedClasses atRandom;
		sizeInBytes: 100;
		finalizationTime: Time primUTCMicrosecondsClock;
		updateStatistics;
		yourself ]
]
