Class {
	#name : 'AllocationGraphVizu',
	#superclass : 'Object',
	#instVars : [
		'layoutClass'
	],
	#category : 'AllocationCallGraph-Profiler-UI-AllocationCallGraph',
	#package : 'AllocationCallGraph-Profiler-UI',
	#tag : 'AllocationCallGraph'
}

{ #category : 'drawing - roassal' }
AllocationGraphVizu >> buildGraphCanvasFor: anAllocationGraph [

	| canvas |
	canvas := RSCanvas new.
	canvas addAll: (self nodesAsRoassalShapes: anAllocationGraph nodes).
	canvas nodes @ RSDraggable new.
	canvas @ RSCanvasController new.

	RSLineBuilder arrowedLine
		color: Color black;
		withBorderAttachPoint;
		shapes: canvas nodes;
		useAssociations: (anAllocationGraph nodes 
				flatCollect: [ :each | each edges collect: [ :call | each -> call targetNode ] ]).

	layoutClass on: canvas nodes.
	^ canvas
]

{ #category : 'drawing - roassal' }
AllocationGraphVizu >> buildInspectorPresenterFor: anAllocationGraph [

	^ self
		  buildInspectorPresenterFor: anAllocationGraph
		  withBuilder: (SpPresenterBuilder new
				   application: StPharoApplication current;
				   yourself)
]

{ #category : 'drawing - roassal' }
AllocationGraphVizu >> buildInspectorPresenterFor: anAllocationGraph withBuilder: aBuilder [

	| c |
	c := self buildGraphCanvasFor: anAllocationGraph.
	^ (aBuilder instantiate: SpRoassalInspectorPresenter)
		  canvas: c;
		  yourself
]

{ #category : 'initialization' }
AllocationGraphVizu >> initialize [

	super initialize.
	layoutClass := RSSugiyamaLayout
]

{ #category : 'drawing - roassal' }
AllocationGraphVizu >> nodesAsRoassalShapes: nodes [

	|nodesAsRoassalShapes |

	nodesAsRoassalShapes := RSComposite models: nodes forEach: [ :shape :model |
		| box label |
		label := RSLabel new
			text: model asString;
			color: Color black;
			yourself.
		box := RSCircle new
			extent: label extent y @ label extent y;
			color: Color white;
			borderColor: Color black.
		shape
			add: box;
			add: label;
			yourself ].
	^ nodesAsRoassalShapes
]

{ #category : 'drawing - roassal' }
AllocationGraphVizu >> withTreeLayout [

	layoutClass := RSTreeLayout
]
