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
IllimaniGCBenchmarker >> bench1GBDF [
	"Loading a 1.6GB DataFrame"

	"https://www.kaggle.com/datasets/rahulbanerjee123/aws-product-length?resource=download"

	self startBench.
	DataFrame readFromCsv: '/Users/sebastian/Downloads/csv/train.csv' asFileReference.
	self stopBench
]

{ #category : #benchmarking }
IllimaniGCBenchmarker >> bench3GBDF [
	"Loading a 3.11GB DataFrame"

	"https://www.kaggle.com/datasets/antoninadolgorukova/proteinrna-vs-rna-spearman-correlation-data?select=Prot-RNA_corr_63gr.csv"

	self startBench.
	DataFrame readFromCsv:
		'/Users/sebastian/Downloads/csv/Prot-RNA_corr_63gr.csv' asFileReference.
	self stopBench
]

{ #category : #benchmarking }
IllimaniGCBenchmarker >> bench500MBDF [
	"Loading a 529 MB DataFrame"

	"https://www.kaggle.com/datasets/rahulbanerjee123/aws-product-length?resource=download"

	self startBench.
	DataFrame readFromCsv: '/Users/sebastian/Downloads/csv/test.csv' asFileReference.
	self stopBench
]

{ #category : #accessing }
IllimaniGCBenchmarker >> edenSize [

	^  Smalltalk vm parameterAt: 44
]

{ #category : #accessing }
IllimaniGCBenchmarker >> fullGCRatio [

	^ Smalltalk vm parameterAt: 55
]

{ #category : #'gc - tunning' }
IllimaniGCBenchmarker >> fullGCRatio: anIntegerInBytes [

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

	^ Smalltalk vm parameterAt: 25
]

{ #category : #'gc - tunning' }
IllimaniGCBenchmarker >> growthHeadroom: anIntegerInBytes [

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

	^ Smalltalk vm parameterAt: 24
]

{ #category : #'gc - tunning' }
IllimaniGCBenchmarker >> shrinkThreshold: anIntegerInBytes [

	Smalltalk vm parameterAt: 24 put: anIntegerInBytes
]

{ #category : #actions }
IllimaniGCBenchmarker >> startBench [

	incrementalGCs := Smalltalk vm incrementalGCCount.
	fullGCs := Smalltalk vm fullGCCount.
	timeGarbageCollectingInMilliseconds := Smalltalk vm totalGCTime
]

{ #category : #actions }
IllimaniGCBenchmarker >> stopBench [

	incrementalGCs := Smalltalk vm incrementalGCCount - incrementalGCs.
	fullGCs := Smalltalk vm fullGCCount - fullGCs.
	timeGarbageCollectingInMilliseconds := Smalltalk vm totalGCTime
	                                       - timeGarbageCollectingInMilliseconds.
	'incremental GCs: ' trace. incrementalGCs trace.
	' full GCs: ' trace. fullGCs trace.
	' time spent garbage collecting: ' trace. timeGarbageCollectingInMilliseconds trace.
	String cr trace.
	
	'eden size: ' trace. self edenSize humanReadableByteSizeString trace.
	' growth headroom: ' trace. self growthHeadroom humanReadableByteSizeString trace.
	' shrink threshold: ' trace. self shrinkThreshold humanReadableByteSizeString trace.
	' full gc ratio: ' trace . self fullGCRatio trace.
]

{ #category : #accessing }
IllimaniGCBenchmarker >> timeGarbageCollectingInMilliseconds [

	^ timeGarbageCollectingInMilliseconds
]

{ #category : #accessing }
IllimaniGCBenchmarker >> timeGarbageCollectingInMilliseconds: anObject [

	timeGarbageCollectingInMilliseconds := anObject
]
