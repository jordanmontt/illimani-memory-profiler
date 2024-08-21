Class {
	#name : 'IllAbstractExporterTest',
	#superclass : 'TestCase',
	#instVars : [
		'exporter',
		'mockProfiler',
		'mockGCMonitor'
	],
	#category : 'IllimaniProfiler-Tests-Exporters',
	#package : 'IllimaniProfiler-Tests',
	#tag : 'Exporters'
}

{ #category : 'testing' }
IllAbstractExporterTest class >> isAbstract [

	^ self = IllAbstractExporterTest
]

{ #category : 'asserting' }
IllAbstractExporterTest >> assertCSVContent: csvReader [

	self subclassResponsibility
]

{ #category : 'asserting' }
IllAbstractExporterTest >> assertHeader: csvReader [

	| actualHeader |
	actualHeader := csvReader next.
	self assert: self expectedCSVHeader equals: actualHeader
]

{ #category : 'asserting' }
IllAbstractExporterTest >> assertJSONMetaData: jsonDictionary [

	self assert: (jsonDictionary at: #profiledCode) equals: mockProfiler profiledCode.
	self assert: (jsonDictionary at: #samplingRate) equals: mockProfiler samplingRate.
	self assert: (jsonDictionary at: #profiler) equals: mockProfiler class asString.
	self assert: (jsonDictionary at: #totalFullGCs) equals: mockProfiler totalFullGCs.
	self assert: (jsonDictionary at: #totalScavenges) equals: mockProfiler totalScavenges.
	self assert: (jsonDictionary at: #totalExecutionTime) equals: mockProfiler totalTime
]

{ #category : 'tests' }
IllAbstractExporterTest >> expectedCSVHeader [

	^ self subclassResponsibility
]

{ #category : 'exporting' }
IllAbstractExporterTest >> exporterClass [

	^ self subclassResponsibility
]

{ #category : 'running' }
IllAbstractExporterTest >> fakeAllocations [

	^ self subclassResponsibility
]

{ #category : 'running' }
IllAbstractExporterTest >> setUp [

	super setUp.
	mockGCMonitor := IllMockGCMonitor new.
	mockProfiler := IllMockProfiler new
		objectAllocations: self fakeAllocations;
		gcMonitor: mockGCMonitor;
		yourself.
	exporter := self exporterClass new
		profiler: mockProfiler;
		yourself
]

{ #category : 'tests' }
IllAbstractExporterTest >> testExportData [

	| csvReader createdCSVFile createdJSONFile jsonDictionary |
	exporter exportData.

	createdCSVFile := (exporter baseFileName , '.csv') asFileReference.
	self assert: createdCSVFile exists.

	createdJSONFile := (exporter baseFileName , '.json') asFileReference.
	self assert: createdJSONFile exists.

	csvReader := NeoCSVReader on: createdCSVFile readStream.
	self assertHeader: csvReader.
	self assertCSVContent: csvReader.

	jsonDictionary := NeoJSONReader fromString: createdJSONFile readStream contents.
	self assertJSONMetaData: jsonDictionary.

	createdCSVFile ensureDelete.
	createdJSONFile ensureDelete
]
