Class {
	#name : 'BasicAllocationInfoModel',
	#superclass : 'Object',
	#instVars : [
		'allocatedObjectClass',
		'finalizationTimestamp',
		'initializationTimestamp',
		'sizeInBytes'
	],
	#category : 'IllimaniAllocationProfiler-Model',
	#package : 'IllimaniAllocationProfiler',
	#tag : 'Model'
}

{ #category : 'accessing' }
BasicAllocationInfoModel >> allocatedObjectClass [

	^ allocatedObjectClass
]

{ #category : 'accessing' }
BasicAllocationInfoModel >> allocatedObjectClass: anObject [

	allocatedObjectClass := anObject
]

{ #category : 'accessing' }
BasicAllocationInfoModel >> finalizationTimestamp [
	"In microseconds"

	^ finalizationTimestamp
]

{ #category : 'accessing' }
BasicAllocationInfoModel >> finalizationTimestamp: anObject [
	"In microseconds"

	finalizationTimestamp := anObject
]

{ #category : 'finalization' }
BasicAllocationInfoModel >> finalize [

	finalizationTimestamp := Time microsecondClockValue
]

{ #category : 'accessing' }
BasicAllocationInfoModel >> initializationTimestamp [
	"In microseconds"

	^ initializationTimestamp
]

{ #category : 'accessing' }
BasicAllocationInfoModel >> initializationTimestamp: microsecondsAsInt [
	"In microseconds"

	initializationTimestamp := microsecondsAsInt
]

{ #category : 'accessing' }
BasicAllocationInfoModel >> lifetime [

	^ finalizationTimestamp - initializationTimestamp
]

{ #category : 'accessing' }
BasicAllocationInfoModel >> lifetimeAsDuration [

	^ Duration microSeconds: self lifetime
]

{ #category : 'accessing' }
BasicAllocationInfoModel >> lifetimeAsString [

	finalizationTimestamp ifNil: [ ^ '-' ].
	^ self lifetimeAsDuration humanReadablePrintString
]

{ #category : 'accessing' }
BasicAllocationInfoModel >> sizeInBytes [
	"Returns the size in memory in bytes"

	^ sizeInBytes
]

{ #category : 'accessing' }
BasicAllocationInfoModel >> sizeInBytes: aNumber [

	sizeInBytes := aNumber
]

{ #category : 'accessing' }
BasicAllocationInfoModel >> timestampAsSeconds [

	^ initializationTimestamp / 1000000
]
