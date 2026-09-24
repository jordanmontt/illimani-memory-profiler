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
FiLiPEphemeron >> inspectorPath: aBuilder [

	<inspectorPresentationOrder: 2 title: 'Allocation Path'>
	^ self sendersCallStack buildInspectorPresenter: aBuilder
]

{ #category : '*FiLiP-MemoryProfiler-UI' }
FiLiPEphemeron >> timeAsMegaBytes [

	^ initializationTime // 1000000
]
