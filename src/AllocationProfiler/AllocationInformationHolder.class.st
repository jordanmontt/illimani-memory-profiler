"
I am an object that hols the information that was was captured by the method proxies
"
Class {
	#name : #AllocationInformationHolder,
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
AllocationInformationHolder class >> allocatedObject: objectCreated [

	^ self new
		allocatedObject: objectCreated;
		timestamp: DateAndTime now;
		yourself
]

{ #category : #'instance creation' }
AllocationInformationHolder class >> context: aContext allocatedObject: objectCreated [

	^ self new
		context: aContext;
		allocatedObject: objectCreated;
		timestamp: DateAndTime now;
		yourself
]

{ #category : #accessing }
AllocationInformationHolder >> allocatedObject [

	^ allocatedObject
]

{ #category : #accessing }
AllocationInformationHolder >> allocatedObject: anObject [

	allocatedObject := anObject
]

{ #category : #accessing }
AllocationInformationHolder >> allocatedObjectClass [

	^ allocatedObjectClass
]

{ #category : #accessing }
AllocationInformationHolder >> allocatedObjectClass: anObject [

	allocatedObjectClass := anObject
]

{ #category : #accessing }
AllocationInformationHolder >> allocatedObjectHash [

	^ allocatedObjectHash
]

{ #category : #accessing }
AllocationInformationHolder >> allocatedObjectHash: anObject [

	allocatedObjectHash := anObject
]

{ #category : #accessing }
AllocationInformationHolder >> allocatorClass [

	^ allocatorClass
]

{ #category : #accessing }
AllocationInformationHolder >> allocatorClass: anObject [

	allocatorClass := anObject
]

{ #category : #accessing }
AllocationInformationHolder >> allocatorMethodName: anObject [

	allocatorMethodName := anObject
]

{ #category : #accessing }
AllocationInformationHolder >> context [

	^ context
]

{ #category : #accessing }
AllocationInformationHolder >> context: anObject [

	context := anObject
]

{ #category : #accessing }
AllocationInformationHolder >> fullMethodName [

	^ allocatorMethodName
]

{ #category : #printing }
AllocationInformationHolder >> printOn: aStream [

	aStream << allocatorClass asString << ' --> ' << allocatedObject class asString << ' --> '
	<< timestamp nanoSecond asString
]

{ #category : #accessing }
AllocationInformationHolder >> timestamp [

	^ timestamp
]

{ #category : #accessing }
AllocationInformationHolder >> timestamp: anObject [

	timestamp := anObject
]
