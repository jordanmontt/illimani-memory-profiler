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
		'forcedFinalization',
		'allocationSite',
		'allocatorClass',
		'programCounter'
	],
	#category : 'IllimaniProfiler-Profiler',
	#package : 'IllimaniProfiler',
	#tag : 'Profiler'
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
IllEphemeron >> allocationSite [

	^ allocationSite
]

{ #category : 'accessing' }
IllEphemeron >> allocationSite: aMethod [

	allocationSite := aMethod
]

{ #category : 'accessing' }
IllEphemeron >> allocatorClass [

	^ allocatorClass
]

{ #category : 'accessing' }
IllEphemeron >> allocatorClass: anObject [

	allocatorClass := anObject
]

{ #category : 'accessing' }
IllEphemeron >> finalizationTime [

	^ finalizationTime
]

{ #category : 'accessing' }
IllEphemeron >> finalizationTime: anObject [

	finalizationTime := anObject
]

{ #category : 'exporting' }
IllEphemeron >> flattenedInstanceVariables [

	^ {
		  finalizationTime.
		  sizeInBytes.
		  initializationTime.
		  allocatedObjectClass.
		  survivedScavenges.
		  survivedFullGC.
		  forcedFinalization.
		  allocationSite name }
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
	"initializationTime := Time primUTCMicrosecondsClock."
	initializationTime := Smalltalk vm parameterAt: 34.
	survivedScavenges := Smalltalk vm incrementalGCCount.
	survivedFullGC := Smalltalk vm fullGCCount.
	forcedFinalization := false
]

{ #category : 'inspector - extensions' }
IllEphemeron >> inspectionElements [

	^ {
		  ('Allocated Object Class' -> allocatedObjectClass).
		  ('Object''s lifetime' -> self lifetimeAsDuration humanReadablePrintString).
		  ('Allocation site' -> allocationSite).
		  ('Memory Size' -> sizeInBytes humanReadableByteSizeString).
		  ('Survived scavenges' -> survivedScavenges).
		  ('Survived full GCs' -> survivedFullGC).
		  ('Initialization time' -> initializationTime).
		  ('Finalization time' -> finalizationTime).
		  ('Finalization was forced?' -> forcedFinalization) }
]

{ #category : 'inspector - extensions' }
IllEphemeron >> inspectorExtension: aBuilder [

	<inspectorPresentationOrder: 0 title: 'Overview'>
	| tablePresenter  items |
	items := self inspectionElements collect: [ :e | StInspectorAssociationNode hostObject: e ].
	tablePresenter := aBuilder newTable.
	tablePresenter
		addColumn: (SpStringTableColumn title: 'Name' evaluated: #key);
		addColumn: (SpStringTableColumn title: 'Value' evaluated: #value);
		items: items;
		beResizable.
	^ tablePresenter
]

{ #category : 'inspector - extensions' }
IllEphemeron >> inspectorExtensionSenders: aBuilder [

	"<inspectorPresentationOrder: 2 title: 'Senders'>"
	| senders |
	"senders not yet implemented"
	^ aBuilder newList
		items: (senders reject: #isNil);
		display: [ :aMethod | "we ask the method because of the compiled blocks" aMethod method name ];
		yourself
]

{ #category : 'accessing' }
IllEphemeron >> lifetime [

	^ finalizationTime - initializationTime
]

{ #category : 'accessing' }
IllEphemeron >> lifetimeAsDuration [

	^ Duration microSeconds: finalizationTime - initializationTime
]

{ #category : 'finalization' }
IllEphemeron >> mourn [

	key ifNil: [ ^ self ].

	allocatedObjectClass := key class.
	sizeInBytes := key sizeInMemory.

	key := nil.

	"finalizationTime := Time primUTCMicrosecondsClock."
	finalizationTime := Smalltalk vm parameterAt: 34.
	self updateStatistics
]

{ #category : 'printing' }
IllEphemeron >> printOn: aStream [

	aStream << allocatedObjectClass name << ' lifetime: '
	<< self lifetimeAsDuration totalSeconds asFloat asString << ' seconds' << ' weights '
	<< sizeInBytes humanReadableByteSizeString
]

{ #category : 'accessing' }
IllEphemeron >> programCounter [

	^ programCounter
]

{ #category : 'accessing' }
IllEphemeron >> programCounter: anObject [

	programCounter := anObject
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

{ #category : 'finalization' }
IllEphemeron >> updateStatistics [
	"When the vm calls the method mourn, it is right before of the collection of the object.
	So we need to add 1 to the counter of scavenges."

	survivedScavenges := Smalltalk vm incrementalGCCount - survivedScavenges + 1.
	survivedFullGC := Smalltalk vm fullGCCount - survivedFullGC
]
