Class {
	#name : 'AllocationBasicInfoModel',
	#superclass : 'Object',
	#instVars : [
		'allocatedObjectClass',
		'sizeInBytes'
	],
	#category : 'IllimaniProfiler-Model-Allocation',
	#package : 'IllimaniProfiler',
	#tag : 'Model-Allocation'
}

{ #category : 'accessing' }
AllocationBasicInfoModel >> allocatedObjectClass [

	^ allocatedObjectClass
]

{ #category : 'accessing' }
AllocationBasicInfoModel >> allocatedObjectClass: anObject [

	allocatedObjectClass := anObject
]

{ #category : 'inspector - extensions' }
AllocationBasicInfoModel >> inspectableAssociations [

	^ {
		  ('Allocated Object Class' -> allocatedObjectClass).
		  ('Memory Size' -> sizeInBytes humanReadableByteSizeString) }
]

{ #category : 'inspector - extensions' }
AllocationBasicInfoModel >> inspectorExtension: aBuilder [

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
AllocationBasicInfoModel >> sizeInBytes [
	"Returns the size in memory in bytes"

	^ sizeInBytes
]

{ #category : 'accessing' }
AllocationBasicInfoModel >> sizeInBytes: aNumber [

	sizeInBytes := aNumber
]
