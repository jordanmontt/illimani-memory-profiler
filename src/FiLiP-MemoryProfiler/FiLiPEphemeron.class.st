Class {
	#name : 'FiLiPEphemeron',
	#superclass : 'Association',
	#type : 'ephemeron',
	#instVars : [
		'finalizationTime',
		'sizeInBytes',
		'initializationTime',
		'allocatedObjectClass',
		'survivedScavenges',
		'survivedFullGC',
		'offset',
		'sendersCallStackCollection',
		'textualAllocatorMethod'
	],
	#category : 'FiLiP-MemoryProfiler-Profiler',
	#package : 'FiLiP-MemoryProfiler',
	#tag : 'Profiler'
}

{ #category : 'comparing' }
FiLiPEphemeron >> = anObject [

	^ self == anObject
]

{ #category : 'accessing' }
FiLiPEphemeron >> allocatedObjectClass [

	^ allocatedObjectClass
]

{ #category : 'allocation site' }
FiLiPEphemeron >> allocationSenders [

	^ self sendersCallStack copyUpTo: textualAllocatorMethod
]

{ #category : 'allocation site' }
FiLiPEphemeron >> allocationSite [

	^ IllMethodWithOffset method: textualAllocatorMethod offset: offset
]

{ #category : 'accessing' }
FiLiPEphemeron >> finalizationTime [

	^ finalizationTime
]

{ #category : 'exporting' }
FiLiPEphemeron >> flattenedInstanceVariables [

	^ {
		  finalizationTime.
		  sizeInBytes.
		  initializationTime.
		  allocatedObjectClass.
		  survivedScavenges.
		  survivedFullGC.
		  textualAllocatorMethod name.
		  offset }
]

{ #category : 'finalization' }
FiLiPEphemeron >> forceFinalization [

	"If already finalized"
	key ifNil: [ ^ self ].
	self mourn
]

{ #category : 'comparing' }
FiLiPEphemeron >> hash [

	^ self identityHash
]

{ #category : 'accessing' }
FiLiPEphemeron >> initializationTime [

	^ initializationTime
]

{ #category : 'initialization' }
FiLiPEphemeron >> initialize [

	super initialize.
	"initializationTime := Time primUTCMicrosecondsClock."
	initializationTime := Smalltalk vm parameterAt: 34.
	survivedScavenges := Smalltalk vm incrementalGCCount.
	survivedFullGC := Smalltalk vm fullGCCount
]

{ #category : 'inspector - extensions' }
FiLiPEphemeron >> inspectionElements [

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

{ #category : 'accessing' }
FiLiPEphemeron >> lifetime [

	^ finalizationTime - initializationTime
]

{ #category : 'finalization' }
FiLiPEphemeron >> mourn [

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
FiLiPEphemeron >> offset [

	^ offset
]

{ #category : 'accessing' }
FiLiPEphemeron >> offset: anObject [

	offset := anObject
]

{ #category : 'printing' }
FiLiPEphemeron >> printOn: aStream [

	aStream << allocatedObjectClass name << ' lifetime: '
	<< self lifetime humanReadableByteSizeString << ' size: '
	<< sizeInBytes humanReadableByteSizeString
]

{ #category : 'allocation site' }
FiLiPEphemeron >> sendersCallStack [

	^ IllSendersCallStack senders: sendersCallStackCollection
]

{ #category : 'allocation site' }
FiLiPEphemeron >> sendersCallStack: aList [

	sendersCallStackCollection := aList
]

{ #category : 'accessing' }
FiLiPEphemeron >> sizeInBytes [

	^ sizeInBytes
]

{ #category : 'accessing' }
FiLiPEphemeron >> survivedFullGC [

	^ survivedFullGC
]

{ #category : 'accessing' }
FiLiPEphemeron >> survivedScavenges [

	^ survivedScavenges
]

{ #category : 'accessing' }
FiLiPEphemeron >> textualAllocatorMethod [

	^ textualAllocatorMethod
]

{ #category : 'accessing' }
FiLiPEphemeron >> textualAllocatorMethod: anObject [

	textualAllocatorMethod := anObject
]
