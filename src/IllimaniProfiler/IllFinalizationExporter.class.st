Class {
	#name : 'IllFinalizationExporter',
	#superclass : 'Object',
	#instVars : [
		'profiler'
	],
	#category : 'IllimaniProfiler-File-Exporters',
	#package : 'IllimaniProfiler',
	#tag : 'File-Exporters'
}

{ #category : 'instance creation' }
IllFinalizationExporter class >> on: aProfiler [

	^ self new
		profiler: aProfiler;
		yourself
]

{ #category : 'exporting' }
IllFinalizationExporter >> exportData [

	| baseFileName |
	baseFileName := self fileNameToExport.
	
	self exportMetaData: baseFileName , '.json'.
	self exportEphemerons: baseFileName , '.csv'.
	self exportGCActivity: baseFileName
]

{ #category : 'exporting' }
IllFinalizationExporter >> exportEphemerons: fileName [

	| writeStream writer |
	writeStream := fileName asFileReference createFile writeStream.
	writer := (NeoCSVWriter on: writeStream)
		writeHeader: profiler ephemeronsCollection first headerToExportCSV;
		fieldWriter: #raw;
		yourself.
	
	profiler ephemeronsCollection do: [ :anIllEphemeron |
		writer nextPut: anIllEphemeron flatInstanceVariables ].

	writer close
]

{ #category : 'exporting' }
IllFinalizationExporter >> exportGCActivity: baseFileName [

	profiler gcActivityMonitor exportData: baseFileName
]

{ #category : 'exporting' }
IllFinalizationExporter >> exportMetaData: fileName [

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
IllFinalizationExporter >> fileNameToExport [

	| fileName |
	fileName := DateAndTime now asStringYMDHM.
	fileName
		replaceAll: Character space with: $H;
		replaceAll: $: with: $m.
	^ fileName
]

{ #category : 'accessing' }
IllFinalizationExporter >> profiler: aProfiler [

	profiler := aProfiler
]
