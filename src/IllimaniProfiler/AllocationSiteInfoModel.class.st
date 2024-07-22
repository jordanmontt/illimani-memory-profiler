Class {
	#name : 'AllocationSiteInfoModel',
	#superclass : 'Object',
	#instVars : [
		'allocatedObjectClass',
		'sizeInBytes',
		'allocatorMethod',
		'initializationTime',
		'senders'
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

	^ allocatorMethod methodClass
]

{ #category : 'accessing' }
AllocationSiteInfoModel >> allocatorMethod [

	^ allocatorMethod
]

{ #category : 'accessing' }
AllocationSiteInfoModel >> allocatorMethod: aCompiledMethod [

	allocatorMethod := aCompiledMethod
]

{ #category : 'exporting' }
AllocationSiteInfoModel >> flattenedInstanceVariables [

	^ {
		  allocatedObjectClass.
		  sizeInBytes.
		  initializationTime.
		  self allocatorClass.
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

{ #category : 'initialization' }
AllocationSiteInfoModel >> initialize [

	super initialize.
	"always in micro-seconds"
	initializationTime := Time primUTCMicrosecondsClock.
	senders := Array new: 10
]

{ #category : 'inspector - extensions' }
AllocationSiteInfoModel >> inspectableAssociations [

	^ {
		  ('Allocated object class' -> allocatedObjectClass).
		  ('Memory size' -> sizeInBytes humanReadableByteSizeString).
		  ('Allocator class' -> self allocatorClass).
		  ('Allocator method' -> allocatorMethod name).
		  ('Initialization timestamp' -> initializationTime) }
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
AllocationSiteInfoModel >> inspectorExtensionSenders: aBuilder [

	<inspectorPresentationOrder: 2 title: 'Senders'>
	^ aBuilder newList
		items: (senders reject: #isNil);
		display: [ :aMethod | "we ask the method because of the compiled blocks" aMethod method name ];
		yourself
]

{ #category : 'printing' }
AllocationSiteInfoModel >> printOn: aStream [

	aStream << allocatorMethod name << ' allocated a ' << allocatedObjectClass asString
	<< ' that weights '.
	sizeInBytes ifNil: [ aStream << ' - ' ]
		ifNotNil: [ aStream << sizeInBytes humanReadableByteSizeString ]
]

{ #category : 'accessing' }
AllocationSiteInfoModel >> senders [

	^ senders
]

{ #category : 'accessing' }
AllocationSiteInfoModel >> senders: anArray [

	senders := anArray
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
