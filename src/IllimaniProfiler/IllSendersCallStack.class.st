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

{ #category : 'api' }
IllSendersCallStack >> buildInspectorPresenter [

	| items filteredSenders |
	filteredSenders := senders reject: #isNil.
	items := OrderedCollection new.
	1 to: filteredSenders size by: 2 do: [ :i |
		| method offset |
		method := senders at: i.
		offset := senders at: i + 1.
		items add: (MethodWithOffset method: method offset: offset) ].
	^ SpTablePresenter new
		  activateOnSingleClick;
		  items: items;
		  addColumn: (SpStringTableColumn title: 'Sender' evaluated: [ :each | each method method name ]);
		  addColumn: (SpStringTableColumn title: 'Offset' evaluated: [ :e | e offset ]);
		  yourself
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

{ #category : 'inspector' }
IllSendersCallStack >> inspector [

	<inspectorPresentationOrder: 0 title: 'Senders call stack'>
	^ self buildInspectorPresenter
]

{ #category : 'accessing' }
IllSendersCallStack >> senders [
	^ senders
]

{ #category : 'accessing' }
IllSendersCallStack >> senders: aCollection [ 
	senders := aCollection
]
