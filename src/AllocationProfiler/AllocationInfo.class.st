"
I am a class that holds the information that was was captured by the method proxies. Like the class of the allocated object, who allocated that object, the timestamp, etc.
"
Class {
	#name : #AllocationInfo,
	#superclass : #Object,
	#instVars : [
		'context',
		'timestamp',
		'allocatedObject',
		'allocatedObjectHash',
		'allocatorClass',
		'allocatorMethodName',
		'allocatedObjectClass'
	],
	#category : #'AllocationProfiler-Data-Structures'
}

{ #category : #'instance creation' }
AllocationInfo class >> allocatedObject: objectCreated [

	^ self new
		allocatedObject: objectCreated;
		timestamp: DateAndTime now;
		yourself
]

{ #category : #'instance creation' }
AllocationInfo class >> context: aContext allocatedObject: objectCreated [

	^ self new
		context: aContext;
		allocatedObject: objectCreated;
		timestamp: DateAndTime now;
		yourself
]

{ #category : #accessing }
AllocationInfo >> allocatedObject [

	^ allocatedObject
]

{ #category : #accessing }
AllocationInfo >> allocatedObject: anObject [

	allocatedObject := anObject
]

{ #category : #accessing }
AllocationInfo >> allocatedObjectClass [

	^ allocatedObjectClass
]

{ #category : #accessing }
AllocationInfo >> allocatedObjectClass: anObject [

	allocatedObjectClass := anObject
]

{ #category : #accessing }
AllocationInfo >> allocatedObjectHash [

	^ allocatedObjectHash
]

{ #category : #accessing }
AllocationInfo >> allocatedObjectHash: anObject [

	allocatedObjectHash := anObject
]

{ #category : #accessing }
AllocationInfo >> allocatorClass [

	^ allocatorClass
]

{ #category : #accessing }
AllocationInfo >> allocatorClass: anObject [

	allocatorClass := anObject
]

{ #category : #accessing }
AllocationInfo >> allocatorMethodName: anObject [

	allocatorMethodName := anObject
]

{ #category : #accessing }
AllocationInfo >> context [

	^ context
]

{ #category : #accessing }
AllocationInfo >> context: anObject [

	context := anObject
]

{ #category : #accessing }
AllocationInfo >> fullMethodName [

	^ allocatorMethodName
]

{ #category : #printing }
AllocationInfo >> printOn: aStream [

	aStream << allocatorMethodName << ' -> ' << allocatedObjectClass asString
]

{ #category : #accessing }
AllocationInfo >> timestamp [

	^ timestamp
]

{ #category : #accessing }
AllocationInfo >> timestamp: anObject [

	timestamp := anObject
]
