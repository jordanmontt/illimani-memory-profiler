Class {
	#name : #IllimaniGCBenchmarker,
	#superclass : #Object,
	#instVars : [
		'incrementalGCs',
		'fullGCs',
		'timeGarbageCollectingInMilliseconds',
		'timeToRun'
	],
	#category : #IllimaniBenchmarker
}

{ #category : #benchmarking }
IllimaniGCBenchmarker >> bench: aBlock [

	incrementalGCs := Smalltalk vm incrementalGCCount.
	fullGCs := Smalltalk vm fullGCCount.
	timeGarbageCollectingInMilliseconds := Smalltalk vm totalGCTime.

	timeToRun := aBlock timeToRun.

	incrementalGCs := Smalltalk vm incrementalGCCount - incrementalGCs.
	fullGCs := Smalltalk vm fullGCCount - fullGCs.
	timeGarbageCollectingInMilliseconds := Smalltalk vm totalGCTime
	                                       - timeGarbageCollectingInMilliseconds.

	^ timeToRun
]
