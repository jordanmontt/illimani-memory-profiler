"
An IllFinalizationExporterTest is a test class for testing the behavior of IllFinalizationExporter
"
Class {
	#name : 'IllFinalizationExporterTest',
	#superclass : 'TestCase',
	#instVars : [
		'exporter',
		'header',
		'mockProfiler',
		'mockGCMonitor'
	],
	#category : 'IllimaniProfiler-Tests',
	#package : 'IllimaniProfiler-Tests'
}

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

{ #category : 'running' }
IllFinalizationExporterTest >> setUp [

	super setUp.
	mockGCMonitor := IllMockGCMonitor new.
	mockProfiler := IllMockProfiler new
		objectAllocations: self fakeAllocations;
		gcMonitor: mockGCMonitor;
		yourself.
	exporter := IllFinalizationExporter new
		profiler: mockProfiler;
		yourself
]

{ #category : 'tests' }
IllFinalizationExporterTest >> testExportData [

	| readStream csvReader actualHeader line createdFile |
	header := #( 'finalizationTimeInMicroSeconds' 'sizeInBytes' 'initializationTimeInMicroSeconds'
		'allocatedObjectClass' 'survivedScavenges' 'survivedFullGCs' 'forcedFinalization' ).
	exporter exportData.
	
	createdFile := (exporter baseFileName , '.csv') asFileReference.
	self assert: createdFile exists.
	
	readStream := createdFile readStream.
	csvReader := NeoCSVReader on: readStream.
	
	actualHeader := csvReader next.
	line := csvReader next.
	
	self assert: header equals: actualHeader.
	self assert: line first asInteger > 100000000.
	self assert: line second asInteger equals: 100 "size".
	self assert: (line fourth asClassInEnvironment:Smalltalk globals) isClass.
	self assert: line last equals: 'false'.
	
	createdFile delete
]
