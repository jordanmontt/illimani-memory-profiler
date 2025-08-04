Class {
	#name : 'FiLiPExporter',
	#superclass : 'IllSimpleExporter',
	#category : 'FiLiP-MemoryProfiler-Profiler',
	#package : 'FiLiP-MemoryProfiler',
	#tag : 'Profiler'
}

{ #category : 'instance creation' }
FiLiPExporter class >> on: aProfiler [

	^ self new
		profiler: aProfiler;
		yourself
]

{ #category : 'exporting' }
FiLiPExporter >> exportAllocationModelCollection [

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
FiLiPExporter >> exportData [

	super exportData.
	self exportAllocationModelCollection
]

{ #category : 'exporting' }
FiLiPExporter >> headerOfAllocationModel [

	^ #( #finalizationTimeInMicroSeconds #sizeInBytes #initializationTimeInMicroSeconds
	     #allocatedObjectClass #survivedScavenges #survivedFullGCs #textualAllocatorMethod #textualAllocatorMethodOffset )
]

{ #category : 'exporting' }
FiLiPExporter >> jsonDictionary [

	| avgLifetimes |
	avgLifetimes := ((profiler objectAllocations sum: #lifetime)
	                 / profiler objectAllocations size) asFloat.

	^ super jsonDictionary
		add: 'averageLifetimes' -> avgLifetimes;
		yourself
]
