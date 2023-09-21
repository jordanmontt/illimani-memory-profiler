Class {
	#name : 'BasicAllocationInfoModel',
	#superclass : 'Object',
	#instVars : [
		'allocatedObjectClass',
		'sizeInBytes',
		'finalizationTime',
		'initializationTime'
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
BasicAllocationInfoModel >> finalizationTime [
	"In microseconds"

	^ finalizationTime
]

{ #category : 'accessing' }
BasicAllocationInfoModel >> finalizationTime: anObject [
	"In microseconds"

	finalizationTime := anObject
]

{ #category : 'finalization' }
BasicAllocationInfoModel >> finalize [

	finalizationTime := Time microsecondClockValue
]

{ #category : 'accessing' }
BasicAllocationInfoModel >> initializationTime [
	"In microseconds"

	^ initializationTime
]

{ #category : 'accessing' }
BasicAllocationInfoModel >> initializationTime: microsecondsAsInt [
	"In microseconds"

	initializationTime := microsecondsAsInt
]

{ #category : 'accessing' }
BasicAllocationInfoModel >> lifetime [

	^ finalizationTime - initializationTime
]

{ #category : 'accessing' }
BasicAllocationInfoModel >> lifetimeAsDuration [

	^ Duration microSeconds: self lifetime
]

{ #category : 'accessing' }
BasicAllocationInfoModel >> lifetimeAsString [

	finalizationTime ifNil: [ ^ '-' ].
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
BasicAllocationInfoModel >> timeAsSeconds [

	^ initializationTime / 1000000
]
