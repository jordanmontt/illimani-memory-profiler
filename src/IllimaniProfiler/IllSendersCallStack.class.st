Class {
	#name : 'IllSendersCallStack',
	#superclass : 'Object',
	#instVars : [
		'senders'
	],
	#category : 'IllimaniProfiler-Profiler',
	#package : 'IllimaniProfiler',
	#tag : 'Profiler'
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

{ #category : 'api' }
IllSendersCallStack >> buildInspectorPresenter [

	| items filteredSenders |
	filteredSenders := senders reject: #isNil.
	items := OrderedCollection new.
	1 to: filteredSenders size by: 2 do: [ :i |
		| method offset |
		method := senders at: i.
		offset := senders at: i + 1.
		items add: (IllMethodWithOffset method: method offset: offset) ].
	^ SpTablePresenter new
		activateOnSingleClick;
		items: items;
		addColumn: (SpIndexTableColumn new title: 'Index'; width: 40; yourself);
		addColumn: (SpStringTableColumn title: 'Sender' evaluated: [ :each | each method method name ]);
		addColumn: (SpStringTableColumn title: 'Offset' evaluated: [ :e | e offset ]);
		yourself
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

{ #category : 'testing' }
IllSendersCallStack >> hasDoItSelector [

	^ (self first: 5) asMethodWithOffsetObjects anySatisfy: [ :methodWithOffset |
		  methodWithOffset method selector = #DoIt ]
]

{ #category : 'comparing' }
IllSendersCallStack >> hash [

	^ senders hash
]

{ #category : 'inspector' }
IllSendersCallStack >> inspector [

	<inspectorPresentationOrder: 0 title: 'Senders call stack'>
	^ self buildInspectorPresenter
]

{ #category : 'accessing' }
IllSendersCallStack >> methodWithOffsetDo: aBlock [

	^ senders pairsCollect: aBlock
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
