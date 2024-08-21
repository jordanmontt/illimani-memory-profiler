"
An IllFinalizationExporterTest is a test class for testing the behavior of IllFinalizationExporter
"
Class {
	#name : 'IllMemoryProfilerExporterTest',
	#superclass : 'IllAbstractExporterTest',
	#category : 'IllimaniProfiler-Tests-Exporters',
	#package : 'IllimaniProfiler-Tests',
	#tag : 'Exporters'
}

{ #category : 'asserting' }
IllMemoryProfilerExporterTest >> assertCSVContent: csvReader [

	| line allocatorMethod |
	line := csvReader next.
	self assert: line second asInteger equals: 100. "size"
	self assert: line first asInteger > line third asInteger. " finalizationTime > initializationTime"
	self assert: (line fourth asClassInEnvironment: Smalltalk globals) isClass. "allocatedClass"
	self assert: line fifth asInteger >= 0. "survived scavenges"
	self assert: line sixth asInteger >= 0. "survived full gcs"
	self assert: line seventh equals: 'false'. "forced finalization"

	allocatorMethod := Smalltalk compiler evaluate: line eighth.
	self assert: allocatorMethod class equals: CompiledMethod "the allocation site is string with the name of a VALID method"
]

{ #category : 'tests' }
IllMemoryProfilerExporterTest >> expectedCSVHeader [

	^ #( 'finalizationTimeInMicroSeconds' 'sizeInBytes' 'initializationTimeInMicroSeconds'
	     'allocatedObjectClass' 'survivedScavenges' 'survivedFullGCs' 'forcedFinalization' 'allocationSite' )
]

{ #category : 'exporting' }
IllMemoryProfilerExporterTest >> exporterClass [

	^ IllMemoryProfilerExporter
]

{ #category : 'running' }
IllMemoryProfilerExporterTest >> fakeAllocations [

	| allocatedClasses allocationSites |
	allocatedClasses := 'Kernel' asPackage definedClasses asArray first: 10.
	allocationSites := ('Kernel' asPackage definedClasses flatCollect: #methods) asArray first: 10.

	^ (1 to: 1000) collect: [ :i | IllEphemeron new
		allocatedObjectClass: allocatedClasses atRandom;
		allocationSite: allocationSites atRandom;
		sizeInBytes: 100;
		finalizationTime: Time primUTCMicrosecondsClock;
		updateStatistics;
		yourself ]
]
