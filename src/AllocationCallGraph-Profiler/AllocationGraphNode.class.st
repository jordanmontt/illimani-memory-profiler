Class {
	#name : 'AllocationGraphNode',
	#superclass : 'AllocationGraphComponent',
	#instVars : [
		'method',
		'edges',
		'callers',
		'allocationPaths',
		'incomingEdges',
		'allocatedObjectTypes'
	],
	#category : 'AllocationCallGraph-Profiler-AllocationCallGraph',
	#package : 'AllocationCallGraph-Profiler',
	#tag : 'AllocationCallGraph'
}

{ #category : 'api' }
AllocationGraphNode >> addCallTo: anAllocationGraphNode withOffset: anOffset [

	^ edges
		  at: (IllMethodWithOffset method: anAllocationGraphNode method offset: anOffset)
		  ifAbsentPut: [
		  AllocationGraphEdge targetNode: anAllocationGraphNode sourceNode: self offset: anOffset ]
]

{ #category : 'api' }
AllocationGraphNode >> addCaller: anAllocationGraphNode [

	callers add: anAllocationGraphNode
]

{ #category : 'api' }
AllocationGraphNode >> addIncomingEdge: anEdge [

    incomingEdges add: anEdge
]

{ #category : 'accessing' }
AllocationGraphNode >> allocatedObjectTypes [

    ^ allocatedObjectTypes ifNil: [
          allocatedObjectTypes := self allocatedSamples collect: #allocatedObjectClass as: Set ]
]

{ #category : 'api - accessing' }
AllocationGraphNode >> allocatedSamples [

	self isLeaf ifTrue: [
		^ callers
			flatCollect: [ :caller | (caller edgeTo: self) allocatedSamples ]
			as: Set ].

	^ edges values flatCollect: #allocatedSamples
]

{ #category : 'accessing' }
AllocationGraphNode >> allocationCallStacks [

	^ allocationPaths
]

{ #category : 'accessing' }
AllocationGraphNode >> allocationCallStacks: aCollection [ 
	allocationPaths := aCollection
]

{ #category : 'api' }
AllocationGraphNode >> appendCallStack: aCollection [

	allocationPaths add: aCollection
]

{ #category : 'accessing' }
AllocationGraphNode >> callers [

	^ callers
]

{ #category : 'accessing' }
AllocationGraphNode >> callers: aSet [

	callers := aSet
]

{ #category : 'copying' }
AllocationGraphNode >> copy [

	| edgesCopy callersCopy allocationPathsCopy |
	edgesCopy := edges collect: [ :edge | edge shallowCopy ].
	callersCopy := callers collect: [ :caller | caller shallowCopy ].
	allocationPathsCopy := allocationPaths collect: [ :collection |
		                       collection collect: [ :obj | obj shallowCopy ] ].

	^ self shallowCopy
		  edges: edgesCopy;
		  callers: callersCopy;
		  allocationCallStacks: allocationPathsCopy;
		  yourself
]

{ #category : 'api - accessing' }
AllocationGraphNode >> edgeForOffset: anInteger [ 

	^ edges detect: [ :edge | edge offset = anInteger ]
]

{ #category : 'api - accessing' }
AllocationGraphNode >> edgeTo: aTargetNode [

	^ edges detect: [ :edge | edge targetNode = aTargetNode ]
]

{ #category : 'api - accessing' }
AllocationGraphNode >> edgeTo: aTargetNode ifFound: ifFoundBlock [

	^ edges
		  detect: [ :edge | edge targetNode = aTargetNode ]
		  ifFound: ifFoundBlock
]

{ #category : 'api - accessing' }
AllocationGraphNode >> edgeTo: aTargetNode ifFound: foundBlock ifNone: noneBlock [

	^ edges
		  detect: [ :edge | edge targetNode = aTargetNode ]
		  ifFound: foundBlock
		  ifNone: noneBlock
]

{ #category : 'accessing' }
AllocationGraphNode >> edges [

	^ edges values
]

{ #category : 'accessing' }
AllocationGraphNode >> edges: anObject [

	edges := anObject
]

{ #category : 'api - accessing' }
AllocationGraphNode >> incomingEdges [

    ^ incomingEdges
]

{ #category : 'initialization' }
AllocationGraphNode >> initialize [

    super initialize.
    edges := Dictionary new.
    callers := Set new.
    incomingEdges := Set new.
    allocationPaths := Set new
]

{ #category : 'inspector' }
AllocationGraphNode >> inspector: aBuilder [

    <inspectorPresentationOrder: 0 title: 'Method'>
    ^ aBuilder newPresenter
          layout: (SpBoxLayout newTopToBottom
                   spacing: 3;
                   add: (aBuilder newText text: method method name; yourself) expand: false;
                   add: (method inspectionSource: aBuilder);
                   yourself);
          yourself
]

{ #category : 'inspector' }
AllocationGraphNode >> inspectorAllocationPath: aBuilder [

    <inspectorPresentationOrder: 1 title: 'Allocation paths'>
    ^ allocationPaths inspectionItems: aBuilder
]

{ #category : 'inspector' }
AllocationGraphNode >> inspectorIncomingEdges: aBuilder [

    <inspectorPresentationOrder: 3 title: 'Incoming Edges'>
    ^ self incomingEdges inspectionItems: aBuilder
]

{ #category : 'inspector' }
AllocationGraphNode >> inspectorOutgoingEdges: aBuilder [

    <inspectorPresentationOrder: 2 title: 'Edges'>
    ^ self edges inspectionItems: aBuilder
]

{ #category : 'testing' }
AllocationGraphNode >> isLeaf [

	^ edges isEmpty
]

{ #category : 'testing' }
AllocationGraphNode >> isRoot [

	^ callers isEmpty
]

{ #category : 'accessing' }
AllocationGraphNode >> method [

	^ method
]

{ #category : 'accessing' }
AllocationGraphNode >> method: aCollection [

	method := aCollection
]

{ #category : 'printing' }
AllocationGraphNode >> printOn: aStream [

	aStream
		print: method methodClass;
		nextPutAll: '>>';
		print: method selector
]
