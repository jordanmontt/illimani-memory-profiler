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
	self assert: line second asInteger equals: 100. "size"
	self assert: line first asInteger > line third asInteger. " finalizationTime > initializationTime"
	self assert: (line fourth asClassInEnvironment: Smalltalk globals) isClass. "allocatedClass"
	self assert: line fifth asInteger >= 0. "survived scavenges"
	self assert: line sixth asInteger >= 0. "survived full gcs"
	self assert: line seventh equals: 'false' "forced finalization"
]

{ #category : 'tests' }
IllFinalizationExporterTest >> expectedCSVHeader [

	^ #( 'finalizationTimeInMicroSeconds' 'sizeInBytes' 'initializationTimeInMicroSeconds'
	     'allocatedObjectClass' 'survivedScavenges' 'survivedFullGCs' 'forcedFinalization' )
]

{ #category : 'exporting' }
IllFinalizationExporterTest >> exporterClass [

	^ IllObjectLifetimesExporter
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
