Extension { #name : 'IllEphemeron' }

{ #category : '*IllimaniUI' }
IllEphemeron >> inspectorExtension: aBuilder [

	<inspectorPresentationOrder: 0 title: 'Overview'>
	| tablePresenter elements items |
	elements := {
		('Allocated Object Class' -> allocatedObjectClass ).
		('Memory Size' -> sizeInBytes humanReadableByteSizeString).
	 	('Initialization time' -> initializationTime).
		('Finalization time' -> finalizationTime).
		('Object''s lifetime' -> self lifetimeAsDuration humanReadablePrintString).
		('Survived scavenges' -> survivedScavenges).
		('Survived full GCs' -> survivedFullGC).
		('Finalization was forced?' -> forcedFinalization) }.
	items := elements collect: [ :e | StInspectorAssociationNode hostObject: e ].
	tablePresenter := aBuilder newTable.
	tablePresenter
		addColumn: (SpStringTableColumn title: 'Name' evaluated: #key);
		addColumn: (SpStringTableColumn title: 'Value' evaluated: #value);
		items: items;
		beResizable.
	^ tablePresenter
]
