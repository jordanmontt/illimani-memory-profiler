Class {
	#name : 'BasicAllocationInfoModel',
	#superclass : 'Object',
	#instVars : [
		'allocatedObjectClass',
		'sizeInBytes',
		'finalizationTime',
		'initializationTime'
	],
	#category : 'IllimaniProfiler-Model-Allocation',
	#package : 'IllimaniProfiler',
	#tag : 'Model-Allocation'
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

{ #category : 'inspector - extensions' }
BasicAllocationInfoModel >> inspectableAssociations [

	^ {
		  ('Allocated Object Class' -> allocatedObjectClass).
		  ('Memory Size' -> sizeInBytes humanReadableByteSizeString).
		  ('Initialization timestamp' -> initializationTime).
		  ('Finalization timestamp' -> finalizationTime).
		  ('Object''s lifetime' -> self lifetimeAsString) }
]

{ #category : 'inspector - extensions' }
BasicAllocationInfoModel >> inspectorExtension: aBuilder [

	<inspectorPresentationOrder: 0 title: 'Overview'>
	| tablePresenter elements items |
	elements := self inspectableAssociations.
	items := elements collect: [ :e | StInspectorAssociationNode hostObject: e ].
	tablePresenter := aBuilder newTable.
	tablePresenter
		addColumn: (SpStringTableColumn title: 'Name' evaluated: #key);
		addColumn: (SpStringTableColumn title: 'Value' evaluated: #value);
		items: items;
		beResizable.
	^ tablePresenter
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
