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
		'allocatorMethod',
		'senders',
		'allocationSenderChain',
		'offset'
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
IllEphemeron >> allocationSenderChain: anArray [

	allocationSenderChain := anArray
]

{ #category : 'allocation site' }
IllEphemeron >> allocationSenders [
	"Replace basic new because it was the trap method when it was captured"

	| filteredSenders |
	filteredSenders := allocationSenderChain select: #isNotNil.
	filteredSenders ifNotEmpty: [
		allocationSenderChain at: 1 put: (OpalCompiler new
				 source: allocationSenderChain first name;
				 evaluate) ].

	^ IllSendersCallStack senders: filteredSenders , {
			  allocatorMethod.
			  offset }
]

{ #category : 'allocation site' }
IllEphemeron >> allocationSite [

	^ IllAllocationSite method: allocatorMethod offset: offset
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
		  allocatorMethod name.
		  offset }
]

{ #category : 'finalization' }
IllEphemeron >> forceFinalization [

	"If already finalized"
	key ifNil: [ ^ self ].
	self mourn
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
	survivedFullGC := Smalltalk vm fullGCCount
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
IllEphemeron >> inspectorExtensionSenders [

	<inspectorPresentationOrder: 2 title: 'Senders call stack'>
	^ self sendersCallStack buildInspectorPresenter
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

{ #category : 'accessing' }
IllEphemeron >> offset [

	^ offset
]

{ #category : 'accessing' }
IllEphemeron >> offset: anObject [

	offset := anObject
]

{ #category : 'printing' }
IllEphemeron >> printOn: aStream [

	aStream << allocatedObjectClass name << ' lifetime: '
	<< self lifetime humanReadableByteSizeString << ' size: '
	<< sizeInBytes humanReadableByteSizeString
]

{ #category : 'allocation site' }
IllEphemeron >> sendersCallStack [

	^ IllSendersCallStack senders: (allocationSenderChain select: #isNotNil) , senders
]

{ #category : 'allocation site' }
IllEphemeron >> sendersCallStack: aContext [

	| sender i n |
	n := 200.
	senders := Array new: n.
	i := 1.
	sender := aContext.
	[ sender isNil or: [ i > n ] ] whileFalse: [
		senders at: i put: sender method.
		senders at: i + 1 put: sender pc - 1.
		sender := sender sender.
		i := i + 2 ]
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
