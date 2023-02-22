"
I am a class that holds the information that was was captured by the method proxies. Like the class of the allocated object, who allocated that object, the timestamp, etc.
"
Class {
	#name : #AllocationInfoDTO,
	#superclass : #Object,
	#instVars : [
		'context',
		'timestamp',
		'allocatedObject',
		'allocatedObjectHash',
		'allocatorClass',
		'allocatorMethodName',
		'allocatedObjectClass',
		'totalSizeInBytes'
	],
	#category : #'AllocationProfiler-Data-Structures'
}

{ #category : #'instance creation' }
AllocationInfoDTO class >> allocatedObject: objectCreated [

	^ self new
		allocatedObject: objectCreated;
		timestamp: DateAndTime now;
		yourself
]

{ #category : #'instance creation' }
AllocationInfoDTO class >> context: aContext allocatedObject: objectCreated [

	^ self new
		context: aContext;
		allocatedObject: objectCreated;
		timestamp: DateAndTime now;
		yourself
]

{ #category : #accessing }
AllocationInfoDTO >> allocatedObject [

	^ allocatedObject
]

{ #category : #accessing }
AllocationInfoDTO >> allocatedObject: anObject [

	allocatedObject := anObject
]

{ #category : #accessing }
AllocationInfoDTO >> allocatedObjectClass [

	^ allocatedObjectClass
]

{ #category : #accessing }
AllocationInfoDTO >> allocatedObjectClass: anObject [

	allocatedObjectClass := anObject
]

{ #category : #accessing }
AllocationInfoDTO >> allocatedObjectHash [

	^ allocatedObjectHash
]

{ #category : #accessing }
AllocationInfoDTO >> allocatedObjectHash: anObject [

	allocatedObjectHash := anObject
]

{ #category : #accessing }
AllocationInfoDTO >> allocatorClass [

	^ allocatorClass
]

{ #category : #accessing }
AllocationInfoDTO >> allocatorClass: anObject [

	allocatorClass := anObject
]

{ #category : #accessing }
AllocationInfoDTO >> allocatorMethodName: anObject [

	allocatorMethodName := anObject
]

{ #category : #accessing }
AllocationInfoDTO >> context [

	^ context
]

{ #category : #accessing }
AllocationInfoDTO >> context: anObject [

	context := anObject
]

{ #category : #accessing }
AllocationInfoDTO >> fullMethodName [

	^ allocatorMethodName
]

{ #category : #printing }
AllocationInfoDTO >> printOn: aStream [

	aStream << allocatorMethodName << ' allocated a ' << allocatedObjectClass asString
	<< ' that weights '.
	totalSizeInBytes ifNil: [ aStream << ' - ' ]
		ifNotNil: [ aStream << totalSizeInBytes humanReadableByteSizeString ]
]

{ #category : #accessing }
AllocationInfoDTO >> timestamp [

	^ timestamp
]

{ #category : #accessing }
AllocationInfoDTO >> timestamp: anObject [

	timestamp := anObject
]

{ #category : #accessing }
AllocationInfoDTO >> totalSizeInBytes [
	"Returns the total size in memory in bytes"

	^ totalSizeInBytes
]

{ #category : #accessing }
AllocationInfoDTO >> totalSizeInBytes: aNumber [

	totalSizeInBytes := aNumber
]
