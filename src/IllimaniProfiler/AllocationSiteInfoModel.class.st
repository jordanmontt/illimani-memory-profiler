Class {
	#name : 'AllocationSiteInfoModel',
	#superclass : 'Object',
	#instVars : [
		'allocatedObjectClass',
		'sizeInBytes',
		'context',
		'allocatorMethod',
		'allocatorClass',
		'contextFingerprint',
		'initializationTime'
	],
	#category : 'IllimaniProfiler-Allocation-Profiler',
	#package : 'IllimaniProfiler',
	#tag : 'Allocation-Profiler'
}

{ #category : 'accessing' }
AllocationSiteInfoModel >> allocatedObjectClass [

	^ allocatedObjectClass
]

{ #category : 'accessing' }
AllocationSiteInfoModel >> allocatedObjectClass: anObject [

	allocatedObjectClass := anObject
]

{ #category : 'accessing' }
AllocationSiteInfoModel >> allocatorClass [

	^ allocatorClass
]

{ #category : 'accessing' }
AllocationSiteInfoModel >> allocatorClass: anObject [

	allocatorClass := anObject
]

{ #category : 'accessing' }
AllocationSiteInfoModel >> allocatorMethod [

	^ allocatorMethod
]

{ #category : 'accessing' }
AllocationSiteInfoModel >> allocatorMethod: aCompiledMethod [

	allocatorMethod := aCompiledMethod
]

{ #category : 'accessing' }
AllocationSiteInfoModel >> context [

	^ context
]

{ #category : 'accessing' }
AllocationSiteInfoModel >> context: anObject [

	context := anObject
]

{ #category : 'accessing' }
AllocationSiteInfoModel >> contextFingerprint [

	^ contextFingerprint
]

{ #category : 'accessing' }
AllocationSiteInfoModel >> contextFingerprint: aContext [

	contextFingerprint := String streamContents: [ :stream | aContext debugStack: 5 on: stream ]
]

{ #category : 'exporting' }
AllocationSiteInfoModel >> flattenedInstanceVariables [

	^ {
		  allocatedObjectClass.
		  sizeInBytes.
		  initializationTime.
		  allocatorClass.
		  allocatorMethod name }
]

{ #category : 'accessing' }
AllocationSiteInfoModel >> fullMethodName [

	^ allocatorMethod name
]

{ #category : 'accessing' }
AllocationSiteInfoModel >> initializationTime [
	"In microseconds"

	^ initializationTime
]

{ #category : 'accessing' }
AllocationSiteInfoModel >> initializationTime: microsecondsAsInt [
	"In microseconds"

	initializationTime := microsecondsAsInt
]

{ #category : 'inspector - extensions' }
AllocationSiteInfoModel >> inspectableAssociations [

	^ super inspectableAssociations , {
		  ('Allocated Object Class' -> allocatedObjectClass).
		  ('Memory Size' -> sizeInBytes humanReadableByteSizeString).
		  ('Initialization timestamp' -> initializationTime).
		  ('Allocator Class' -> allocatorClass).
		  ('Allocator Method' -> allocatorMethod).
		  ('Context' -> context) }
]

{ #category : 'inspector - extensions' }
AllocationSiteInfoModel >> inspectorExtension: aBuilder [

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

{ #category : 'inspector - extensions' }
AllocationSiteInfoModel >> inspectorExtensionContextFingerprint: aBuilder [

	"<inspectorPresentationOrder: 2 title: 'Context Fingerprint'>"
	^ self contextFingerprint contents inspectionFullString
]

{ #category : 'printing' }
AllocationSiteInfoModel >> printOn: aStream [

	aStream << allocatorMethod name << ' allocated a ' << allocatedObjectClass asString
	<< ' that weights '.
	sizeInBytes ifNil: [ aStream << ' - ' ]
		ifNotNil: [ aStream << sizeInBytes humanReadableByteSizeString ]
]

{ #category : 'accessing' }
AllocationSiteInfoModel >> sizeInBytes [
	"Returns the size in memory in bytes"

	^ sizeInBytes
]

{ #category : 'accessing' }
AllocationSiteInfoModel >> sizeInBytes: aNumber [

	sizeInBytes := aNumber
]

{ #category : 'accessing' }
AllocationSiteInfoModel >> timeAsSeconds [

	^ initializationTime / 1000000
]
