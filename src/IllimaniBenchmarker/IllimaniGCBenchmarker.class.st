Class {
	#name : #IllimaniGCBenchmarker,
	#superclass : #Object,
	#instVars : [
		'incrementalGCs',
		'fullGCs',
		'timeGarbageCollectingInMilliseconds',
		'growthHeadroom',
		'shrinkThreshold',
		'fullGCRatio',
		'edenSize'
	],
	#category : #IllimaniBenchmarker
}

{ #category : #benchmarking }
IllimaniGCBenchmarker >> bench [

	self startBench.
	self stopBench
]

{ #category : #benchmarking }
IllimaniGCBenchmarker >> benchOneGBDF [

	self startBench.
	DataFrame readFromCsv: '/Users/sebastian/Downloads/csv/train.csv' asFileReference.
	self stopBench
]

{ #category : #benchmarking }
IllimaniGCBenchmarker >> benchThreeGBDF [

	self startBench.
	DataFrame readFromCsv:
		'/Users/sebastian/Downloads/csv/Prot-RNA_corr_63gr.csv' asFileReference.
	self stopBench
]

{ #category : #accessing }
IllimaniGCBenchmarker >> edenSize [

	^ edenSize
]

{ #category : #accessing }
IllimaniGCBenchmarker >> edenSize: anObject [

	edenSize := anObject
]

{ #category : #accessing }
IllimaniGCBenchmarker >> fullGCRatio [

	^ fullGCRatio
]

{ #category : #'gc - tunning' }
IllimaniGCBenchmarker >> fullGCRatio: anIntegerInBytes [

	fullGCRatio := anIntegerInBytes.
	Smalltalk vm parameterAt: 55 put: anIntegerInBytes
]

{ #category : #accessing }
IllimaniGCBenchmarker >> fullGCs [

	^ fullGCs
]

{ #category : #accessing }
IllimaniGCBenchmarker >> fullGCs: anObject [

	fullGCs := anObject
]

{ #category : #accessing }
IllimaniGCBenchmarker >> growthHeadroom [

	^ growthHeadroom
]

{ #category : #'gc - tunning' }
IllimaniGCBenchmarker >> growthHeadroom: anIntegerInBytes [

	growthHeadroom := anIntegerInBytes.
	Smalltalk vm parameterAt: 25 put: anIntegerInBytes
]

{ #category : #accessing }
IllimaniGCBenchmarker >> incrementalGCs [

	^ incrementalGCs
]

{ #category : #accessing }
IllimaniGCBenchmarker >> incrementalGCs: anObject [

	incrementalGCs := anObject
]

{ #category : #accessing }
IllimaniGCBenchmarker >> shrinkThreshold [

	^ shrinkThreshold
]

{ #category : #'gc - tunning' }
IllimaniGCBenchmarker >> shrinkThreshold: anIntegerInBytes [

	shrinkThreshold := anIntegerInBytes.
	Smalltalk vm parameterAt: 24 put: anIntegerInBytes
]

{ #category : #benchmarking }
IllimaniGCBenchmarker >> startBench [

	incrementalGCs := Smalltalk vm incrementalGCCount.
	fullGCs := Smalltalk vm fullGCCount.
	timeGarbageCollectingInMilliseconds := Smalltalk vm totalGCTime
]

{ #category : #benchmarking }
IllimaniGCBenchmarker >> stopBench [

	incrementalGCs := Smalltalk vm incrementalGCCount - incrementalGCs.
	fullGCs := Smalltalk vm fullGCCount - fullGCs.
	timeGarbageCollectingInMilliseconds := Smalltalk vm totalGCTime
	                                       - timeGarbageCollectingInMilliseconds.
	'incremental GCs: ' trace. incrementalGCs trace.
	' full GCs: ' trace. fullGCs trace.
	' time spent garbage collecting: ' trace. timeGarbageCollectingInMilliseconds trace.
	String cr trace.
	
	'eden size: ' trace. edenSize humanReadableByteSizeString trace.
	' growth headroom: ' trace. growthHeadroom humanReadableByteSizeString trace.
	' shrink threshold: ' trace. shrinkThreshold humanReadableByteSizeString trace.
	' full gc ratio: ' trace . fullGCRatio humanReadableByteSizeString trace.
]

{ #category : #accessing }
IllimaniGCBenchmarker >> timeGarbageCollectingInMilliseconds [

	^ timeGarbageCollectingInMilliseconds
]

{ #category : #accessing }
IllimaniGCBenchmarker >> timeGarbageCollectingInMilliseconds: anObject [

	timeGarbageCollectingInMilliseconds := anObject
]
