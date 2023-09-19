Extension { #name : 'BasicAllocationInfoModel' }

{ #category : '*IllimaniAllocationProfiler-UI' }
BasicAllocationInfoModel >> inspectableAssociations [

	^ {
		  ('Allocated Object Class' -> allocatedObjectClass).
		  ('Total Memory Size' -> totalSizeInBytes humanReadableByteSizeString).
		  ('Initialization timestamp' -> initializationTimestamp).
		  ('Finalization timestamp' -> finalizationTimestamp).
		  ('Object''s lifetime' -> self lifetimeAsString) }
]

{ #category : '*IllimaniAllocationProfiler-UI' }
BasicAllocationInfoModel >> inspectorExtension: aBuilder [

	<inspectorPresentationOrder: 0 title: 'Overview'>
	| tablePresenter elements items |
	elements := self inspectableAssociations.
	items := elements collect: [ :e | StInspectorAssociationNode hostObject: e ].
	tablePresenter := aBuilder newTable.
	tablePresenter
		addColumn: (SpStringTableColumn title: 'Name' evaluated: #key);
		addColumn: (SpStringTableColumn title: 'Value' evaluated: #value);
		items: items;
		beResizable.
	^ tablePresenter
]
