"
I am an optimized stack. I am made for storing methods with their bytecode offset (Integer). I store them in a primitive way. I have an array as instance variable and I store the information as follows:

compiled code
bytecode offset
compiler code
bytecode offset

So the elements stored in my array are always in pairs of two; the first one being a compiled code (compiled method or compiled block) and the second one the integer representing the bytecode offset of the compiled code.

I was creating for inspecting utilities. Storing the elements flat is efficient and me I provide the inspector utilities to easily inspect the stack
"
Class {
	#name : 'IllSendersCallStack',
	#superclass : 'Object',
	#instVars : [
		'senders'
	],
	#category : 'Illimani-FrameworkProfiler-Utilities',
	#package : 'Illimani-FrameworkProfiler',
	#tag : 'Utilities'
}

{ #category : 'accessing' }
IllSendersCallStack class >> senders: aCollection [

	^ self new
		  senders: aCollection;
		  yourself
]

{ #category : 'comparing' }
IllSendersCallStack >> = illSenders [

	self class = illSenders class ifFalse: [ ^ false ].
	^ senders = illSenders senders
]

{ #category : 'accessing' }
IllSendersCallStack >> asMethodWithOffsetObjects [

	^ self methodWithOffsetDo:[ :method :offset | IllMethodWithOffset method: method offset: offset ]
]

{ #category : 'accessing' }
IllSendersCallStack >> at: index [

	^ IllMethodWithOffset method: (senders at: index * 2 - 1) offset: (senders at: index * 2)
]

{ #category : 'accessing' }
IllSendersCallStack >> copyUpTo: aMethod [

	| index |
	index := senders indexOf: aMethod.
	^ self class new senders: (senders copyFrom: 1 to: index + 1)
]

{ #category : 'api' }
IllSendersCallStack >> first: n [

	^ self class new
		  senders: (senders first: n * 2);
		  yourself
]

{ #category : 'comparing' }
IllSendersCallStack >> hash [

	^ senders hash
]

{ #category : 'accessing' }
IllSendersCallStack >> methodWithOffsetDo: aBlock [

	^ senders pairsCollect: aBlock
]

{ #category : 'printing' }
IllSendersCallStack >> printOn: aStream [

	super printOn: aStream.
	senders ifNotNil: [
			aStream << ' '.
			senders size / 2 printOn: aStream.
			aStream << ' items' ]
]

{ #category : 'accessing' }
IllSendersCallStack >> senders [
	^ senders
]

{ #category : 'accessing' }
IllSendersCallStack >> senders: anArray [

	senders := anArray reject: #isNil
]

{ #category : 'accessing' }
IllSendersCallStack >> size [

	^ senders size / 2
]
