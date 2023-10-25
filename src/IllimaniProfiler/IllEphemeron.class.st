Class {
	#name : 'IllEphemeron',
	#superclass : 'Association',
	#type : 'ephemeron',
	#instVars : [
		'finalizationTime',
		'sizeInBytes',
		'initializationTime',
		'allocatedObjectClass',
		'survivedScavenges',
		'survivedFullGC',
		'forcedFinalization'
	],
	#category : 'IllimaniProfiler-Finalization-Profiler',
	#package : 'IllimaniProfiler',
	#tag : 'Finalization-Profiler'
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

{ #category : 'finalization' }
IllEphemeron >> forceFinalization [

	"If already finalized"
	key ifNil: [ ^ self ].

	forcedFinalization := true.
	self mourn
]

{ #category : 'accessing' }
IllEphemeron >> forcedFinalization [

	^ forcedFinalization
]

{ #category : 'accessing' }
IllEphemeron >> initializationTime [

	^ initializationTime
]

{ #category : 'accessing' }
IllEphemeron >> initializationTime: anObject [

	initializationTime := anObject
]

{ #category : 'initialization' }
IllEphemeron >> initialize [

	super initialize.
	initializationTime := Time primUTCMicrosecondsClock.
	survivedScavenges := Smalltalk vm incrementalGCCount.
	survivedFullGC := Smalltalk vm fullGCCount.
	forcedFinalization := false
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
		('Object''s lifetime' -> self lifetimeAsDuration humanReadablePrintString).
		('Survived # of scavenges' -> survivedScavenges).
		('Survived # of full GCs' -> survivedFullGC).
		('Finalization was forced?' -> forcedFinalization) }.
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

	"key ifNil: [ ^ self ]."

	allocatedObjectClass := key class.
	sizeInBytes := key sizeInMemory.

	key := nil.

	finalizationTime := Time primUTCMicrosecondsClock.
	"When the vm calls the method mourn, it is right before of the collection of the object.
	So we need to add 1 to the counter of scavenges."
	survivedScavenges := Smalltalk vm incrementalGCCount - survivedScavenges + 1.
	survivedFullGC := Smalltalk vm fullGCCount - survivedFullGC
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

{ #category : 'accessing' }
IllEphemeron >> survivedFullGC [

	^ survivedFullGC
]

{ #category : 'accessing' }
IllEphemeron >> survivedScavenges [

	^ survivedScavenges
]
