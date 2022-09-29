"
I am an object that hols the information that was was captured by the method proxies
"
Class {
	#name : #MpInformationHolder,
	#superclass : #Object,
	#instVars : [
		'context',
		'timestamp',
		'createdObject'
	],
	#category : #MethodProxiesSebas
}

{ #category : #'instance creation' }
MpInformationHolder class >> context: aContext createdObject: objectCreated [

	^ self new
		context: aContext;
		createdObject: objectCreated;
		timestamp: DateAndTime now;
		yourself
]

{ #category : #accessing }
MpInformationHolder >> context [

	^ context
]

{ #category : #accessing }
MpInformationHolder >> context: anObject [

	context := anObject
]

{ #category : #accessing }
MpInformationHolder >> createdObject [

	^ createdObject
]

{ #category : #accessing }
MpInformationHolder >> createdObject: anObject [

	createdObject := anObject
]

{ #category : #printing }
MpInformationHolder >> printOn: aStream [

	aStream << context methodClass name << ' --> ' << createdObject class asString << ' --> '
	<< timestamp nanoSecond asString
]

{ #category : #accessing }
MpInformationHolder >> timestamp [

	^ timestamp
]

{ #category : #accessing }
MpInformationHolder >> timestamp: anObject [

	timestamp := anObject
]
