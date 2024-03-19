Class {
	#name : 'IllAbstractExporter',
	#superclass : 'Object',
	#instVars : [
		'profiler',
		'baseFileName'
	],
	#category : 'IllimaniProfiler-File-Exporters',
	#package : 'IllimaniProfiler',
	#tag : 'File-Exporters'
}

{ #category : 'exporting' }
IllAbstractExporter >> exportAllocationModelCollection: fileName [

	| writeStream writer |
	writeStream := fileName asFileReference createFile writeStream.
	writer := (NeoCSVWriter on: writeStream)
		writeHeader: self headerOfAllocationModel;
		fieldWriter: #raw;
		yourself.
	
	profiler objectAllocations do: [ :anAllocationModel |
		writer nextPut: anAllocationModel flattenedInstanceVariables ].

	writer close
]

{ #category : 'exporting' }
IllAbstractExporter >> exportData [

	baseFileName := self fileNameToExport.
	
	self exportMetaData: baseFileName , '.json'.
	self exportAllocationModelCollection: baseFileName , '.csv'.
	self exportGCActivity
]

{ #category : 'exporting' }
IllAbstractExporter >> exportGCActivity [

	profiler gcActivityMonitor exportData: baseFileName
]

{ #category : 'exporting' }
IllAbstractExporter >> exportMetaData: fileName [

	| tempDict jsonString  writeStream |
	tempDict := { ('totalExecutionTime' -> profiler totalTime).
		('totalFullGCs' -> profiler totalFullGCs).
		('profiledCode' -> profiler profiledCode).
		('totalScavenges' -> profiler totalScavenges).
		('sampligRate' -> profiler samplingRate).
		('profiler' -> profiler class name) } asDictionary.
	jsonString := NeoJSONWriter toStringPretty: tempDict.

	writeStream := fileName asFileReference createFile writeStream.
	writeStream nextPutAll: jsonString.
	writeStream close
]

{ #category : 'exporting' }
IllAbstractExporter >> fileNameToExport [

	^ DateAndTime now asStringYMDHMS
]

{ #category : 'exporting' }
IllAbstractExporter >> headerOfAllocationModel [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
IllAbstractExporter >> profiler: aProfiler [

	profiler := aProfiler
]
