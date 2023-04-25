Class {
	#name : #BasicAllocationInfoModel,
	#superclass : #Object,
	#instVars : [
		'allocatedObjectClass',
		'finalizationTimestamp',
		'totalSizeInBytes',
		'initializationTimestamp',
		'gcSpentTime'
	],
	#category : #'IllimaniAllocationProfiler-Model'
}

{ #category : #accessing }
BasicAllocationInfoModel >> allocatedObjectClass [

	^ allocatedObjectClass
]

{ #category : #accessing }
BasicAllocationInfoModel >> allocatedObjectClass: anObject [

	allocatedObjectClass := anObject
]

{ #category : #accessing }
BasicAllocationInfoModel >> finalizationTimestamp [
	"In microseconds"

	^ finalizationTimestamp
]

{ #category : #accessing }
BasicAllocationInfoModel >> finalizationTimestamp: anObject [
	"In microseconds"

	finalizationTimestamp := anObject
]

{ #category : #finalization }
BasicAllocationInfoModel >> finalize [

	finalizationTimestamp := Time microsecondClockValue.
	gcSpentTime := gcSpentTime - Smalltalk vm totalGCTime
]

{ #category : #accessing }
BasicAllocationInfoModel >> initializationTimestamp [
	"In microseconds"

	^ initializationTimestamp
]

{ #category : #accessing }
BasicAllocationInfoModel >> initializationTimestamp: microsecondsAsInt [
	"In microseconds"

	gcSpentTime := Smalltalk vm totalGCTime.
	initializationTimestamp := microsecondsAsInt
]

{ #category : #printing }
BasicAllocationInfoModel >> lifetime [

	^ finalizationTimestamp - initializationTimestamp - gcSpentTime
]

{ #category : #printing }
BasicAllocationInfoModel >> lifetimeAsDuration [

	^ Duration microSeconds: self lifetime
]

{ #category : #printing }
BasicAllocationInfoModel >> lifetimeAsString [

	finalizationTimestamp ifNil: [ ^ '-' ].
	^ self lifetimeAsDuration humanReadablePrintString
]

{ #category : #accessing }
BasicAllocationInfoModel >> timestampAsSeconds [

	^ initializationTimestamp / 1000000
]

{ #category : #accessing }
BasicAllocationInfoModel >> totalSizeInBytes [
	"Returns the total size in memory in bytes"

	^ totalSizeInBytes
]

{ #category : #accessing }
BasicAllocationInfoModel >> totalSizeInBytes: aNumber [

	totalSizeInBytes := aNumber
]
