Class {
	#name : #IllimaniGCBenchmarker,
	#superclass : #Object,
	#instVars : [
		'incrementalGCs',
		'fullGCs',
		'timeGarbageCollectingInMilliseconds',
		'growthHeadroom',
		'shrinkThreshold',
		'fullGCRatio'
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
IllimaniGCBenchmarker >> fullGCRatio [

	^ fullGCRatio
]

{ #category : #accessing }
IllimaniGCBenchmarker >> fullGCRatio: anObject [

	fullGCRatio := anObject
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

{ #category : #accessing }
IllimaniGCBenchmarker >> growthHeadroom: anObject [

	growthHeadroom := anObject
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

{ #category : #accessing }
IllimaniGCBenchmarker >> shrinkThreshold: anObject [

	shrinkThreshold := anObject
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
	'incremental GCs: ' trace.
	incrementalGCs trace.
	' full GCs: ' trace.
	fullGCs trace.
	' time spent garbage collecting: ' trace.
	timeGarbageCollectingInMilliseconds trace
]

{ #category : #accessing }
IllimaniGCBenchmarker >> timeGarbageCollectingInMilliseconds [

	^ timeGarbageCollectingInMilliseconds
]

{ #category : #accessing }
IllimaniGCBenchmarker >> timeGarbageCollectingInMilliseconds: anObject [

	timeGarbageCollectingInMilliseconds := anObject
]
