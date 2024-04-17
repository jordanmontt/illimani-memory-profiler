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
IllAbstractExporter >> exportAllocationModelCollection [

	| writeStream writer fileName |
	
	baseFileName ifNil: [ baseFileName := self fileNameToExport ].
	fileName := baseFileName , '.csv'.
	
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
	
	self exportMetaData.
	self exportAllocationModelCollection.
	self exportGCActivity
]

{ #category : 'exporting' }
IllAbstractExporter >> exportGCActivity [

	profiler gcActivityMonitor exportData: baseFileName
]

{ #category : 'exporting' }
IllAbstractExporter >> exportMetaData [

	| tempDict jsonString  writeStream avgLifetimes fileName |
	
	baseFileName ifNil: [ baseFileName := self fileNameToExport ].
	fileName := baseFileName , '.json'.
	
	avgLifetimes := ((profiler objectAllocations sum: #lifetime)
		/ profiler objectAllocations size) asFloat.

	tempDict := { ('totalExecutionTime' -> profiler totalTime).
		('totalFullGCs' -> profiler totalFullGCs).
		('profiledCode' -> profiler profiledCode).
		('totalScavenges' -> profiler totalScavenges).
		('samplingRate' -> profiler samplingRate).
		('profiler' -> profiler class name).
		('averageLifetimes' -> avgLifetimes) } asDictionary.
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
