"
An IllFinalizationExporterTest is a test class for testing the behavior of IllFinalizationExporter
"
Class {
	#name : 'FiLiPExporterTest',
	#superclass : 'TestCase',
	#instVars : [
		'exporter',
		'mockProfiler',
		'mockGCMonitor',
		'createdCSVFile',
		'createdJSONFile'
	],
	#category : 'FiLiP-MemoryProfiler-Tests-Exporters',
	#package : 'FiLiP-MemoryProfiler-Tests',
	#tag : 'Exporters'
}

{ #category : 'asserting' }
FiLiPExporterTest >> assertCSVContent: csvReader [

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

{ #category : 'asserting' }
FiLiPExporterTest >> assertHeader: csvReader [

	| actualHeader |
	actualHeader := csvReader next.
	self assert: self expectedCSVHeader equals: actualHeader
]

{ #category : 'asserting' }
FiLiPExporterTest >> assertJSONMetaData: jsonDictionary [

	self assert: (jsonDictionary at: #profiledCode) equals: mockProfiler profiledCode.
	self assert: (jsonDictionary at: #samplingRate) equals: mockProfiler samplingRate.
	self assert: (jsonDictionary at: #profiler) equals: mockProfiler class asString.
	self assert: (jsonDictionary at: #totalFullGCs) equals: mockProfiler totalFullGCs.
	self assert: (jsonDictionary at: #totalScavenges) equals: mockProfiler totalScavenges.
	self assert: (jsonDictionary at: #totalExecutionTime) equals: mockProfiler totalTime
]

{ #category : 'tests' }
FiLiPExporterTest >> expectedCSVHeader [

	^ #( 'finalizationTimeInMicroSeconds'
	     'sizeInBytes' 'initializationTimeInMicroSeconds'
	     'allocatedObjectClass' 'survivedScavenges' 'survivedFullGCs'
	     'textualAllocatorMethod' 'textualAllocatorMethodOffset' )
]

{ #category : 'exporting' }
FiLiPExporterTest >> exporterClass [

	^ FiLiPExporter
]

{ #category : 'running' }
FiLiPExporterTest >> fakeAllocations [

	| allocatedClasses allocatorMethods |
	allocatedClasses := { Set . Dictionary }.
	allocatorMethods := ('Kernel' asPackage definedClasses flatCollect: #methods) asArray first: 10.

	^ (1 to: 1000) collect: [ :i | FiLiPEphemeron new
		key: allocatedClasses atRandom new value: nil;
		textualAllocatorMethod: allocatorMethods atRandom;
		offset: 10;
		mourn;
		yourself ]
]

{ #category : 'running' }
FiLiPExporterTest >> setUp [

	super setUp.
	mockProfiler := IllMockProfiler new
		objectAllocations: self fakeAllocations;
		yourself.
	exporter := self exporterClass new
		profiler: mockProfiler;
		yourself
]

{ #category : 'running' }
FiLiPExporterTest >> tearDown [

	createdCSVFile ensureDelete.
	createdJSONFile ensureDelete.
	super tearDown
]

{ #category : 'tests' }
FiLiPExporterTest >> testExportData [

	| csvReader jsonDictionary |
	exporter exportData.

	createdCSVFile := (exporter baseFileName , '.csv') asFileReference.
	self assert: createdCSVFile exists.

	createdJSONFile := (exporter baseFileName , '.json') asFileReference.
	self assert: createdJSONFile exists.

	csvReader := NeoCSVReader on: createdCSVFile readStream.
	self assertHeader: csvReader.
	self assertCSVContent: csvReader.

	jsonDictionary := NeoJSONReader fromString: createdJSONFile readStream contents.
	self assertJSONMetaData: jsonDictionary
]
