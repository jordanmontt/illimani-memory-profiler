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
	line := csvReader next." 'finalizationTimeInMicroSeconds'
	     'sizeInBytes' 'initializationTimeInMicroSeconds'
	     'allocatedObjectClass' 'survivedScavenges' 'survivedFullGCs'
	     'allocatorMethod' 'allocatorMethodByte'"
	self assert: line first asInteger > line third asInteger. " finalizationTime > initializationTime"
	self assert: line second asInteger equals: 24. "size"
	self assert: (line fourth asClassInEnvironment: Smalltalk globals) isClass. "allocatedClass"
	self assert: line fifth asInteger >= 0. "survived scavenges"
	self assert: line sixth asInteger >= 0. "survived full gcs"
	self assert: line eighth asInteger >= 0. "allocatorMethodByte"
	
	allocatorMethod := Smalltalk compiler evaluate: line seventh.
	self assert: allocatorMethod class equals: CompiledMethod "the allocation site is string with the name of a valid method"
]

{ #category : 'tests' }
IllMemoryProfilerExporterTest >> expectedCSVHeader [

	^ #( 'finalizationTimeInMicroSeconds'
	     'sizeInBytes' 'initializationTimeInMicroSeconds'
	     'allocatedObjectClass' 'survivedScavenges' 'survivedFullGCs'
	     'allocatorMethod' 'allocatorMethodOffset' )
]

{ #category : 'exporting' }
IllMemoryProfilerExporterTest >> exporterClass [

	^ IllMemoryProfilerExporter
]

{ #category : 'running' }
IllMemoryProfilerExporterTest >> fakeAllocations [

	| allocatedClasses allocatorMethods |
	allocatedClasses := { Set . Dictionary }.
	allocatorMethods := ('Kernel' asPackage definedClasses flatCollect: #methods) asArray first: 10.

	^ (1 to: 1000) collect: [ :i | IllEphemeron new
		key: allocatedClasses atRandom new value: nil;
		allocatorMethod: allocatorMethods atRandom;
		offset: 10;
		mourn;
		yourself ]
]
