"
I am the simple class that exports the metadata of the profiler. I create a json file for the meta data. Users can extend me..
"
Class {
	#name : 'IllSimpleExporter',
	#superclass : 'Object',
	#instVars : [
		'profiler',
		'baseFileName'
	],
	#category : 'Illimani-FrameworkProfiler-File-Exporters',
	#package : 'Illimani-FrameworkProfiler',
	#tag : 'File-Exporters'
}

{ #category : 'exporting' }
IllSimpleExporter >> exportData [

	baseFileName := self fileNameToExport.
	self exportMetaData
]

{ #category : 'api - exporting' }
IllSimpleExporter >> exportMetaData [

	| tempDict jsonString  writeStream fileName |

	baseFileName ifNil: [ baseFileName := self fileNameToExport ].
	fileName := baseFileName , '.json'.

	tempDict := self jsonDictionary.
	jsonString := NeoJSONWriter toStringPretty: tempDict.

	writeStream := fileName asFileReference createFile writeStream.
	writeStream nextPutAll: jsonString.
	writeStream close
]

{ #category : 'exporting' }
IllSimpleExporter >> fileNameToExport [

	^ DateAndTime now asStringYMDHMS
]

{ #category : 'exporting' }
IllSimpleExporter >> jsonDictionary [

	^ {
		  ('totalExecutionTime' -> profiler totalTime).
		  ('totalFullGCs' -> profiler totalFullGCs).
		  ('profiledCode' -> profiler profiledCode).
		  ('totalScavenges' -> profiler totalScavenges).
		  ('samplingRate' -> profiler samplingRate).
		  ('profiler' -> profiler class name) } asDictionary
]

{ #category : 'accessing' }
IllSimpleExporter >> profiler: aProfiler [

	profiler := aProfiler
]
