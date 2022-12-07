"
I am an object that hols the information that was was captured by the method proxies
"
Class {
	#name : #AllocationInformationHolder,
	#superclass : #Object,
	#instVars : [
		'context',
		'timestamp',
		'createdObject'
	],
	#category : #MethodProxiesSebas
}

{ #category : #'instance creation' }
AllocationInformationHolder class >> context: aContext createdObject: objectCreated [

	^ self new
		context: aContext;
		createdObject: objectCreated;
		timestamp: DateAndTime now;
		yourself
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
AllocationInformationHolder >> createdObject [

	^ createdObject
]

{ #category : #accessing }
AllocationInformationHolder >> createdObject: anObject [

	createdObject := anObject
]

{ #category : #printing }
AllocationInformationHolder >> printOn: aStream [

	aStream << context methodClass name << ' --> ' << createdObject class asString << ' --> '
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
