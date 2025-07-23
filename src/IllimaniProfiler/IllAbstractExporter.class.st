"
I am the abstract class for the exporters. What I do is basically provide logic for exporting the profiling data as json and csv files.
"
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
	self exportAllocationModelCollection
]

{ #category : 'exporting' }
IllAbstractExporter >> exportMetaData [

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
IllAbstractExporter >> fileNameToExport [

	^ DateAndTime now asStringYMDHMS
]

{ #category : 'exporting' }
IllAbstractExporter >> headerOfAllocationModel [

	^ self subclassResponsibility
]

{ #category : 'exporting' }
IllAbstractExporter >> jsonDictionary [

	^ {
		  ('totalExecutionTime' -> profiler totalTime).
		  ('totalFullGCs' -> profiler totalFullGCs).
		  ('profiledCode' -> profiler profiledCode).
		  ('totalScavenges' -> profiler totalScavenges).
		  ('samplingRate' -> profiler samplingRate).
		  ('profiler' -> profiler class name) } asDictionary
]

{ #category : 'accessing' }
IllAbstractExporter >> profiler: aProfiler [

	profiler := aProfiler
]
