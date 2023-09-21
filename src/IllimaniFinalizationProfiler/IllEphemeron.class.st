Class {
	#name : 'IllEphemeron',
	#superclass : 'Association',
	#type : 'ephemeron',
	#instVars : [
		'finalizationTime',
		'sizeInBytes',
		'initializationTime',
		'allocatedObjectClass'
	],
	#category : 'IllimaniFinalizationProfiler-Ephemerons',
	#package : 'IllimaniFinalizationProfiler',
	#tag : 'Ephemerons'
}

{ #category : 'accessing' }
IllEphemeron >> allocatedObjectClass [

	^ allocatedObjectClass
]

{ #category : 'accessing' }
IllEphemeron >> allocatedObjectClass: anObject [

	allocatedObjectClass := anObject
]

{ #category : 'accessing' }
IllEphemeron >> finalizationTime [

	^ finalizationTime
]

{ #category : 'accessing' }
IllEphemeron >> finalizationTime: anObject [

	finalizationTime := anObject
]

{ #category : 'accessing' }
IllEphemeron >> initializationTime [

	^ initializationTime
]

{ #category : 'accessing' }
IllEphemeron >> initializationTime: anObject [

	initializationTime := anObject
]

{ #category : 'inspector' }
IllEphemeron >> inspectorExtension: aBuilder [

	<inspectorPresentationOrder: 0 title: 'Overview'>
	| tablePresenter elements items |
	elements := {
		('Allocated Object Class' -> allocatedObjectClass ).
		('Memory Size' -> sizeInBytes humanReadableByteSizeString).
	 	('Initialization time' -> initializationTime).
		('Finalization time' -> finalizationTime).
		('Object''s lifetime' -> self lifetimeAsDuration humanReadablePrintString) }.
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
IllEphemeron >> lifetimeAsDuration [

	^ Duration microSeconds: finalizationTime - initializationTime
]

{ #category : 'finalization' }
IllEphemeron >> mourn [

	key ifNil: [ ^ self ].

	key := nil.
	finalizationTime := Time primUTCMicrosecondsClock
]

{ #category : 'printing' }
IllEphemeron >> printOn: aStream [

	aStream << allocatedObjectClass name << ' lifetime: '
	<< self lifetimeAsDuration totalSeconds asFloat asString << ' seconds' << ' weights '
	<< sizeInBytes humanReadableByteSizeString
]

{ #category : 'accessing' }
IllEphemeron >> sizeInBytes [

	^ sizeInBytes
]

{ #category : 'accessing' }
IllEphemeron >> sizeInBytes: anObject [

	sizeInBytes := anObject
]
