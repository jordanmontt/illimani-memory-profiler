Class {
	#name : 'AllocationGraphNode',
	#superclass : 'AllocationGraphComponent',
	#instVars : [
		'method',
		'edges',
		'callers',
		'allocationPaths'
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

{ #category : 'api - accessing' }
AllocationGraphNode >> allocatedSamples [

	self isLeaf ifTrue: [
		^ callers
			flatCollect: [ :caller | (caller edgeTo: self) allocatedSamples ]
			as: Set ].

	^ edges values flatCollect: #allocatedSamples
]

{ #category : 'accessing' }
AllocationGraphNode >> allocationPaths [

	^ allocationPaths
]

{ #category : 'accessing' }
AllocationGraphNode >> allocationPaths: aCollection [ 
	allocationPaths := aCollection
]

{ #category : 'api' }
AllocationGraphNode >> appendPath: aCollection [

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
		  allocationPaths: allocationPathsCopy;
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

{ #category : 'initialization' }
AllocationGraphNode >> initialize [

	super initialize.
	edges := Dictionary new.
	callers := Set new.
	allocationPaths := OrderedCollection new
]

{ #category : 'inspector' }
AllocationGraphNode >> inspector: aBuilder [

	<inspectorPresentationOrder: 0 title: 'Code'>
	^ self inspectorPresenter: aBuilder
]

{ #category : 'inspector' }
AllocationGraphNode >> inspectorAllocationPath: aBuilder [

	<inspectorPresentationOrder: 1 title: 'Path'>
	| callStackRawArray |
	allocationPaths ifNil: [ ^ aBuilder newList ].

	callStackRawArray := allocationPaths allButFirst flatCollect: [ :assoc | { assoc key method . assoc value } ].
	^ (IllSendersCallStack senders: callStackRawArray) buildInspectorPresenter: aBuilder
]

{ #category : 'inspector' }
AllocationGraphNode >> inspectorPresenter: aBuilder [

	^ method inspectionSource: aBuilder
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
