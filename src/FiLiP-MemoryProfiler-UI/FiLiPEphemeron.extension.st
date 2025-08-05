Extension { #name : 'FiLiPEphemeron' }

{ #category : '*FiLiP-MemoryProfiler-UI' }
FiLiPEphemeron >> inspectorExtension: aBuilder [

	<inspectorPresentationOrder: 0 title: 'Overview'>
	| tablePresenter  items |
	items := self inspectionElements collect: [ :e | StInspectorAssociationNode hostObject: e ].
	tablePresenter := aBuilder newTable.
	tablePresenter
		addColumn: (SpStringTableColumn title: 'Name' evaluated: #key);
		addColumn: (SpStringTableColumn title: 'Value' evaluated: #value);
		items: items;
		beResizable.
	^ tablePresenter
]

{ #category : '*FiLiP-MemoryProfiler-UI' }
FiLiPEphemeron >> inspectorExtensionSenders: aBuilder [

	<inspectorPresentationOrder: 2 title: 'Senders call stack'>
	^ self sendersCallStack buildInspectorPresenter: aBuilder
]

{ #category : '*FiLiP-MemoryProfiler-UI' }
FiLiPEphemeron >> timeAsMegaBytes [

	^ initializationTime // 1000000
]
