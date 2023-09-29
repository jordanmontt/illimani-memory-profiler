Class {
	#name : 'AllocationFinalizationInfoModel',
	#superclass : 'AllocationBasicInfoModel',
	#instVars : [
		'finalizationTime',
		'initializationTime'
	],
	#category : 'IllimaniProfiler-Model-Allocation',
	#package : 'IllimaniProfiler',
	#tag : 'Model-Allocation'
}

{ #category : 'accessing' }
AllocationFinalizationInfoModel >> finalizationTime [
	"In microseconds"

	^ finalizationTime
]

{ #category : 'accessing' }
AllocationFinalizationInfoModel >> finalizationTime: anObject [
	"In microseconds"

	finalizationTime := anObject
]

{ #category : 'finalization' }
AllocationFinalizationInfoModel >> finalize [

	finalizationTime := Time microsecondClockValue
]

{ #category : 'accessing' }
AllocationFinalizationInfoModel >> initializationTime [
	"In microseconds"

	^ initializationTime
]

{ #category : 'accessing' }
AllocationFinalizationInfoModel >> initializationTime: microsecondsAsInt [
	"In microseconds"

	initializationTime := microsecondsAsInt
]

{ #category : 'inspector - extensions' }
AllocationFinalizationInfoModel >> inspectableAssociations [

	^ super inspectableAssociations ,  {
		  ('Initialization timestamp' -> initializationTime).
		  ('Finalization timestamp' -> finalizationTime).
		  ('Object''s lifetime' -> self lifetimeAsString) }
]

{ #category : 'accessing' }
AllocationFinalizationInfoModel >> lifetime [

	^ finalizationTime - initializationTime
]

{ #category : 'accessing' }
AllocationFinalizationInfoModel >> lifetimeAsDuration [

	^ Duration microSeconds: self lifetime
]

{ #category : 'accessing' }
AllocationFinalizationInfoModel >> lifetimeAsString [

	finalizationTime ifNil: [ ^ '-' ].
	^ self lifetimeAsDuration humanReadablePrintString
]

{ #category : 'accessing' }
AllocationFinalizationInfoModel >> timeAsSeconds [

	^ initializationTime / 1000000
]
