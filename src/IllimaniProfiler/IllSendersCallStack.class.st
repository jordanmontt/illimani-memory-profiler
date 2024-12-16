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
		| method offset  |
		method := senders at: i.
		offset := senders at: i + 1.
		items add: (StInspectorTransmissionNode
			hostObject: method -> offset
			transmissionBlock: [ :e |
				IllMethodHighlightedBytecodePresenterInspection new method: method; offset: offset; yourself ])].
	^ SpTablePresenter new
		  activateOnSingleClick;
		  items: items;
		  addColumn: (SpStringTableColumn
				   title: 'Sender'
				   evaluated: [ :each | "we ask the method because of the compiled blocks"
					   each hostObject key method name ]);
		  addColumn: (SpStringTableColumn
				   title: 'Bytecode'
				   evaluated: [ :e | e hostObject value ]);
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
