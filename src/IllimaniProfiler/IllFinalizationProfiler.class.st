Class {
	#name : 'IllFinalizationProfiler',
	#superclass : 'IllAbstractProfiler',
	#instVars : [
		'ephemeronsCollection',
		'statsModel',
		'gcLogger'
	],
	#category : 'IllimaniProfiler-Finalization-Profiler',
	#package : 'IllimaniProfiler',
	#tag : 'Finalization-Profiler'
}

{ #category : 'exporting' }
IllFinalizationProfiler >> exportData [

	| baseFileName |
	baseFileName := self fileNameToExport.
	
	self exportMetaData: baseFileName , '.json'.
	self exportEphemerons: baseFileName , '.csv'.
	self exportGCActivity: baseFileName
]

{ #category : 'exporting' }
IllFinalizationProfiler >> exportEphemerons: fileName [

	| writeStream writer |
	writeStream := fileName asFileReference createFile writeStream.
	writer := (NeoCSVWriter on: writeStream)
		writeHeader: ephemeronsCollection first headerToExportCSV;
		fieldWriter: #raw;
		yourself.
	
	ephemeronsCollection do: [ :anIllEphemeron |
		writer nextPut: anIllEphemeron flatInstanceVariables ].

	writer close
]

{ #category : 'exporting' }
IllFinalizationProfiler >> exportGCActivity: baseFileName [

	gcLogger exportData: baseFileName
]

{ #category : 'exporting' }
IllFinalizationProfiler >> exportMetaData: fileName [

	| tempDict jsonString  writeStream |
	tempDict := { ('totalExecutionTime' -> totalTime).
		('totalFullGCs' -> self totalFullGCs).
		('profiledCode' -> profiledCode).
		('totalScavenges' -> self totalScavenges).
		('sampligRate' -> samplingRate) } asDictionary.
	jsonString := NeoJSONWriter toStringPretty: tempDict.

	writeStream := fileName asFileReference createFile writeStream.
	writeStream nextPutAll: jsonString.
	writeStream close
]

{ #category : 'exporting' }
IllFinalizationProfiler >> fileNameToExport [

	| fileName |
	fileName := DateAndTime now asStringYMDHM.
	fileName
		replaceAll: Character space with: $H;
		replaceAll: $: with: $m.
	^ fileName
]

{ #category : 'profiling' }
IllFinalizationProfiler >> forceFinalizationOfObjects [

	ephemeronsCollection do: [ :e | e forceFinalization ]
]

{ #category : 'initialization' }
IllFinalizationProfiler >> initialize [

	super initialize.
	ephemeronsCollection := OrderedCollection new: 10000000
]

{ #category : 'profiling' }
IllFinalizationProfiler >> internalRegisterAllocation: anObject [
	
	ephemeronsCollection add: (IllEphemeron newPinned 
		key: anObject value: nil;
		yourself)
]

{ #category : 'accessing' }
IllFinalizationProfiler >> objectAllocations [

	^ ephemeronsCollection
]

{ #category : 'profiling' }
IllFinalizationProfiler >> startProfiling [

	gcLogger := GCLogger new run.
	super startProfiling.
]

{ #category : 'accessing - statistics' }
IllFinalizationProfiler >> stats [

	^ statsModel ifNil: [ statsModel := FinalizationStatsModel on: ephemeronsCollection ]
]

{ #category : 'profiling' }
IllFinalizationProfiler >> stopProfiling [

	super stopProfiling.
	gcLogger terminate.
	self forceFinalizationOfObjects
]
