Class {
	#name : #IllimaniGCBenchmarker,
	#superclass : #Object,
	#instVars : [
		'incrementalGCs',
		'fullGCs',
		'timeGarbageCollectingInMilliseconds'
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
	'full GCs: ' trace.
	fullGCs trace.
	'time spent garbage collecting: ' trace.
	timeGarbageCollectingInMilliseconds trace
]
