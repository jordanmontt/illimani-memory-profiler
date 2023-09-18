Class {
	#name : 'BasicAllocationInfoModel',
	#superclass : 'Object',
	#instVars : [
		'allocatedObjectClass',
		'finalizationTimestamp',
		'totalSizeInBytes',
		'initializationTimestamp'
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
BasicAllocationInfoModel >> timestampAsSeconds [

	^ initializationTimestamp / 1000000
]

{ #category : 'accessing' }
BasicAllocationInfoModel >> totalSizeInBytes [
	"Returns the total size in memory in bytes"

	^ totalSizeInBytes
]

{ #category : 'accessing' }
BasicAllocationInfoModel >> totalSizeInBytes: aNumber [

	totalSizeInBytes := aNumber
]
