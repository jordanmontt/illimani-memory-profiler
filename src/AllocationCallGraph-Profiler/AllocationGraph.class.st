Class {
	#name : 'AllocationGraph',
	#superclass : 'Object',
	#instVars : [
		'nodes',
		'samples'
	],
	#category : 'AllocationCallGraph-Profiler-AllocationCallGraph',
	#package : 'AllocationCallGraph-Profiler',
	#tag : 'AllocationCallGraph'
}

{ #category : 'instance creation' }
AllocationGraph class >> onSamples: aCollection [

	^ self new
		  setUpForSamples: aCollection;
		  yourself
]

{ #category : 'private' }
AllocationGraph >> accumulateSample: aSample [

	| callee |
	callee := nil.
	aSample sendersCallStack methodWithOffsetDo: [ :method :offset |
		callee
			ifNil: [ (self nodeFor: method) beLeaf ]
			ifNotNil: [ self recordCallFrom: method  to: callee at: offset sample: aSample ].
		
		method selector = #DoIt ifTrue: [ ^ self ].
		callee := method ]
]

{ #category : 'api' }
AllocationGraph >> allPathsFrom: startNode to: endNode [

	| stack association paths currentNode pathUntilNow |
	paths := OrderedCollection new.
	stack := Stack with: (startNode -> { startNode }). 

	[ stack isNotEmpty ] whileTrue: [ 
		association := stack pop.
		currentNode := association key.
		pathUntilNow := association value.

		currentNode = endNode
			ifTrue: [ paths add: pathUntilNow ]
			ifFalse: [  
				currentNode edges do: [ :edge |
					(pathUntilNow includes: edge targetNode) ifFalse: [
						stack push: edge targetNode -> (pathUntilNow copyWith: edge targetNode) ] ] ] ].

		^ paths
]

{ #category : 'accessing' }
AllocationGraph >> allocatedSamples [

	^ nodes values flatCollect: #allocatedSamples as: Set
]

{ #category : 'accessing' }
AllocationGraph >> edgeFrom: aMethod to: anotherMethod [

    ^ (self nodeAtMethod: aMethod) edgeTo: (self nodeAtMethod: anotherMethod)
]

{ #category : 'accessing' }
AllocationGraph >> edges [

	^ nodes values flatCollect: #edges as: Set
]

{ #category : 'initialization' }
AllocationGraph >> initialize [

	super initialize.
	nodes := IdentityDictionary new: 1000
]

{ #category : 'inspector' }
AllocationGraph >> inspectionRaw: aBuilder [
	"Put the raw inspection as ther first tab to avoid freezing the image. The layout of the graph can take time"

	<inspectorPresentationOrder: 0 title: 'Raw'>
	^ aBuilder instantiate: StRawInspectionPresenter on: self
]

{ #category : 'accessing' }
AllocationGraph >> leaves [

	^ nodes values select: [ :node | node isLeaf ]
]

{ #category : 'accessing' }
AllocationGraph >> nodeAtMethod: aMethod [
	"Using the name because of the allocation primitives. When they were captured, the source code contained the 'trapMethod' code. After, if we want to access it later, the trapMethod code has been discared and the normal code it was put back. Because of this we need to use the name else we will get the a key not found error"
	^ nodes at: aMethod ifAbsent: [ self leaves detect: [ :leaf | leaf method name = aMethod name ] ]
]

{ #category : 'private' }
AllocationGraph >> nodeFor: aMethod [

	^ nodes at: aMethod ifAbsentPut: [ AllocationGraphNode new method: aMethod ]
]

{ #category : 'accessing' }
AllocationGraph >> nodes [

	^ nodes values
]

{ #category : 'accessing' }
AllocationGraph >> nodes: aCollection [

	nodes := aCollection
]

{ #category : 'private' }
AllocationGraph >> recordCallFrom: aCaller to: aCallee at: anOffset sample: sample [
	"Caller -> the one that calls. Callee -> the one being called"
	| edge callerNode calleeNode |
	callerNode := self nodeFor: aCaller.
	calleeNode := self nodeFor: aCallee.
	edge := callerNode addCallTo: calleeNode withOffset: anOffset.

	calleeNode addCaller: callerNode.

	edge updateFromSample: sample
]

{ #category : 'accessing' }
AllocationGraph >> samples [
	^ samples
]

{ #category : 'accessing' }
AllocationGraph >> samples: aCollection [

	samples := aCollection
]

{ #category : 'api' }
AllocationGraph >> setUpForSamples: aCollection [

	samples := aCollection.
	aCollection do: [ :sample | self accumulateSample: sample ]
]

{ #category : 'api' }
AllocationGraph >> subgraphForType: aClass [

	^ self class onSamples: (samples select: [ :e | e allocatedObjectClass = aClass ])
]

{ #category : 'api' }
AllocationGraph >> subgraphReachableFromMethod: aCompiledMethod [

    ^ self subgraphReachableFromNode: (self nodeAtMethod: aCompiledMethod)
]

{ #category : 'api' }
AllocationGraph >> subgraphReachableFromNode: aNode [

	| newRoot prunedNodes nodesToTreat visitedNodes |
	newRoot := aNode
		callers: Set new;
		yourself.
	nodesToTreat := Stack with: newRoot.
	prunedNodes := Set with: newRoot.
	visitedNodes := Set new.

	[ nodesToTreat isNotEmpty ] whileTrue: [
		| current targetNodes |
		current := nodesToTreat pop.
		(visitedNodes includes: current) ifFalse: [
			visitedNodes add: current.
			targetNodes := (current edges collect: #targetNode)
					reject: [ :target | visitedNodes includes: target ].
			prunedNodes addAll: targetNodes.
			nodesToTreat addAll: targetNodes ] ].

	self nodes: (prunedNodes collect: [ :node | node method -> node ]) asDictionary.
	^ self
]

{ #category : 'api' }
AllocationGraph >> traverseLongLivedSenderChainsUsing: aStrategy [
    "Performs a DFS algorithm to extract the long lived senders chains. Stops the traversal using a using criteria algorithm."

	| stack currentNode pathUntilNow association |
	stack := Stack newFrom: (self leaves collect: [ :leafNode | leafNode -> {  } ]).

	[ stack isEmpty ] whileFalse: [
		association := stack pop.
		currentNode := association key.
		pathUntilNow := association value.

		"Cut the traversal if we didn't find an allocation site until this depth"
		pathUntilNow size <= 50 ifTrue: [
			(aStrategy isAllocationSite: currentNode fromAllocationPath: pathUntilNow)
				ifTrue: [ currentNode beAllocationSite; appendCallStack: pathUntilNow ]
				ifFalse: [ 
					(currentNode incomingEdges select: #isLongLived) do: [ :edge | 
						(pathUntilNow includes: edge) ifFalse: [ 
							stack add: edge sourceNode -> (pathUntilNow copyWith: edge) ] ] ] ] ]
]
