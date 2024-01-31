Class {
	#name : 'IllFinalizationProfiler',
	#superclass : 'IllAbstractProfiler',
	#instVars : [
		'ephemeronsCollection',
		'statsModel',
		'gcProcess'
	],
	#category : 'IllimaniProfiler-Finalization-Profiler',
	#package : 'IllimaniProfiler',
	#tag : 'Finalization-Profiler'
}

{ #category : 'exporting' }
IllFinalizationProfiler >> exportData [

	| writer writeStream fileName |
	fileName := self fileNameToExport.
	self exportMetaData: fileName , '.json'.

	writeStream := (fileName , '.csv') asFileReference createFile writeStream.
	writer := NeoCSVWriter on: writeStream.

	writer writeHeader: ephemeronsCollection first headerToExportCSV.
	ephemeronsCollection do: [ :anIllEphemeron | 
		writer nextPut: anIllEphemeron flatInstanceVariables ].

	writer close
]

{ #category : 'exporting' }
IllFinalizationProfiler >> exportMetaData: fileName [

	| tempDict jsonString  writeStream |
	tempDict := { ('totalExecutionTime' -> totalTime).
		('totalFullGCs' -> self totalFullGCs).
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
IllFinalizationProfiler >> startGCProcess [

	gcProcess := [
	[ true ] whileTrue: [
		Smalltalk garbageCollect.
		1000 milliSeconds wait ] ] fork
]

{ #category : 'profiling' }
IllFinalizationProfiler >> startProfiling [

	super startProfiling.
	self startGCProcess
]

{ #category : 'accessing - statistics' }
IllFinalizationProfiler >> stats [

	^ statsModel ifNil: [ statsModel := FinalizationStatsModel on: ephemeronsCollection ]
]

{ #category : 'profiling' }
IllFinalizationProfiler >> stopGCProcess [

	gcProcess terminate
]

{ #category : 'profiling' }
IllFinalizationProfiler >> stopProfiling [

	super stopProfiling.
	self stopGCProcess.
	Smalltalk garbageCollect.
	self forceFinalizationOfObjects
]
