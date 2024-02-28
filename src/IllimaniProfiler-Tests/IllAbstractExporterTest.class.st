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

	| csvReader createdFile |
	exporter exportData.
	createdFile := (exporter baseFileName , '.csv') asFileReference.
	self assert: createdFile exists.
	
	csvReader := NeoCSVReader on: createdFile readStream.
	
	self assertHeader: csvReader.
	self assertCSVContent: csvReader.
	
	createdFile delete
]
