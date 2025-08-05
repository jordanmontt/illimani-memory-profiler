Extension { #name : 'IllSendersCallStack' }

{ #category : '*Illimani-FrameworkProfiler-UI' }
IllSendersCallStack >> buildInspectorPresenter: aBuilder [

	| items filteredSenders |
	filteredSenders := senders reject: #isNil.
	items := OrderedCollection new.
	1 to: filteredSenders size by: 2 do: [ :i |
		| method offset |
		method := senders at: i.
		offset := senders at: i + 1.
		items add: (IllMethodWithOffset method: method offset: offset) ].
	^ aBuilder newTable
			activateOnSingleClick;
			items: items;
			addColumn: (SpIndexTableColumn new title: 'Index'; width: 40; yourself);
			addColumn: (SpStringTableColumn title: 'Sender' evaluated: [ :each | each method method name ]);
			addColumn: (SpStringTableColumn title: 'Offset' evaluated: [ :e | e offset ]);
			yourself
]

{ #category : '*Illimani-FrameworkProfiler-UI' }
IllSendersCallStack >> inspector: aBuilder [

	<inspectorPresentationOrder: 0 title: 'Senders call stack'>
	^ self buildInspectorPresenter: aBuilder
]
