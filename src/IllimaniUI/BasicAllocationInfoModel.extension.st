Extension { #name : 'BasicAllocationInfoModel' }

{ #category : '*IllimaniUI' }
BasicAllocationInfoModel >> inspectableAssociations [

	^ {
		  ('Allocated Object Class' -> allocatedObjectClass).
		  ('Memory Size' -> sizeInBytes humanReadableByteSizeString).
		  ('Initialization timestamp' -> initializationTime).
		  ('Finalization timestamp' -> finalizationTime).
		  ('Object''s lifetime' -> self lifetimeAsString) }
]

{ #category : '*IllimaniUI' }
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
