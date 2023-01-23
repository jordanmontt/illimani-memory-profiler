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
		'fullMethodName',
		'objectClass'
	],
	#category : #AllocationProfiler
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
AllocationInformationHolder >> context [

	^ context
]

{ #category : #accessing }
AllocationInformationHolder >> context: anObject [

	context := anObject
]

{ #category : #accessing }
AllocationInformationHolder >> fullMethodName [

	^ fullMethodName
]

{ #category : #accessing }
AllocationInformationHolder >> fullMethodName: anObject [

	fullMethodName := anObject
]

{ #category : #accessing }
AllocationInformationHolder >> objectClass [

	^ objectClass
]

{ #category : #accessing }
AllocationInformationHolder >> objectClass: anObject [

	objectClass := anObject
]

{ #category : #printing }
AllocationInformationHolder >> printOn: aStream [

	aStream << objectClass asString << ' --> ' << allocatedObject class asString << ' --> '
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
