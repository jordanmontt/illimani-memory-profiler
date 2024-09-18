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
		'programCounter',
		'allocatorMethod',
		'senders'
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
IllEphemeron >> allocationSite [

	^ IllAllocationSite method: allocatorMethod byte: self allocatorByte
]

{ #category : 'accessing' }
IllEphemeron >> allocatorByte [

	^ programCounter - 1
]

{ #category : 'accessing' }
IllEphemeron >> allocatorMethod [

	^ allocatorMethod
]

{ #category : 'accessing' }
IllEphemeron >> allocatorMethod: aMethod [

	allocatorMethod := aMethod
]

{ #category : 'accessing' }
IllEphemeron >> finalizationTime [

	^ finalizationTime
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
		  allocatorMethod name.
		  (programCounter - 1) }
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
		  ('Object''s lifetime' -> self lifetime humanReadableByteSizeString).
		  ('Allocation site' -> self allocationSite).
		  ('Memory Size' -> sizeInBytes humanReadableByteSizeString).
		  ('Survived scavenges' -> survivedScavenges).
		  ('Survived full GCs' -> survivedFullGC).
		  ('Finalization was forced?' -> forcedFinalization).
		  ('Initialization time' -> initializationTime humanReadableByteSizeString).
		  ('Finalization time' -> finalizationTime humanReadableByteSizeString) }
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

	<inspectorPresentationOrder: 2 title: 'Senders context'>
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

{ #category : 'finalization' }
IllEphemeron >> mourn [

	key ifNil: [ ^ self ].

	allocatedObjectClass := key class.
	sizeInBytes := key sizeInMemory.

	key := nil.

	"finalizationTime := Time primUTCMicrosecondsClock."
	finalizationTime := Smalltalk vm parameterAt: 34.
	
	survivedScavenges := Smalltalk vm incrementalGCCount - survivedScavenges.
	survivedFullGC := Smalltalk vm fullGCCount - survivedFullGC
]

{ #category : 'printing' }
IllEphemeron >> printOn: aStream [

	aStream << allocatedObjectClass name << ' lifetime: '
	<< self lifetime humanReadableByteSizeString << ' size: '
	<< sizeInBytes humanReadableByteSizeString
]

{ #category : 'accessing' }
IllEphemeron >> programCounter: anObject [

	programCounter := anObject
]

{ #category : 'accessing' }
IllEphemeron >> senders: aContext [

	| sender |
	"Using #to:do: because of performance"

	senders := Array new: 10.
	sender := aContext.
	1 to: 10 do: [ :i |
		sender ifNil: [ ^ self ].
		senders at: i put: sender method.
		sender := sender sender ]
]

{ #category : 'accessing' }
IllEphemeron >> sizeInBytes [

	^ sizeInBytes
]

{ #category : 'accessing' }
IllEphemeron >> survivedFullGC [

	^ survivedFullGC
]

{ #category : 'accessing' }
IllEphemeron >> survivedScavenges [

	^ survivedScavenges
]
