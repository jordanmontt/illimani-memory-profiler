Extension { #name : 'IllSendersCallStack' }

{ #category : '*Illimani-FrameworkProfiler-UI' }
IllSendersCallStack >> buildInspectorPresenter: aBuilder [

	^ aBuilder newTable
			activateOnSingleClick;
			items: self asMethodWithOffsetCollection;
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
