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
AllocationGraph >> edges [

	^ nodes values flatCollect: #edges as: Set
]

{ #category : 'api' }
AllocationGraph >> identifyAllocationSitesUsing: aStrategy [

	| stack current path |
	"If the strategy needs some preprocessing"
	aStrategy setupForGraph: self andSamples: samples.

	stack := self leaves collect: [ :leafNode | leafNode -> { } ] as: OrderedCollection.

	[ stack isEmpty ] whileFalse: [
		current := stack last key.
		path := stack last value.
		stack removeLast.

		"Cut the traversal if we didn't find an allocation site until this depth"
		(path size <= 100) ifTrue: [
			(aStrategy isAllocationSite: current fromAllocationPath: path)
				ifTrue: [ current beAllocationSite; appendPath: path ]
				ifFalse: [ 
					current callers do: [ :caller | 
						caller
							edgeTo: current
							ifFound: [ :edge |
								(path includes: edge) ifFalse: [ 
									stack add: caller -> (path copyWith: edge) ] ] ] ] ] ]
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

{ #category : 'api' }
AllocationGraph >> pruneFromRoot: aNode [

	| newRoot newNodes nodesToTreat visitesNodes |
	newRoot := aNode copy
		callers: Set new;
		yourself.
	nodesToTreat := OrderedCollection with: newRoot.
	newNodes := Set with: newRoot.
	visitesNodes := OrderedCollection new.

	[ nodesToTreat isNotEmpty ] whileTrue: [
		| current targetNodes |
		current := nodesToTreat removeFirst.
		(visitesNodes includes: current) ifFalse: [
			visitesNodes add: current.
			targetNodes := (current edges collect: #targetNode) 
					reject: [ :target | visitesNodes includes: target ].
			newNodes addAll: targetNodes.
			nodesToTreat addAll: targetNodes ] ].

	^ self class new
		  nodes: (newNodes collect: [ :node | node method -> node ]) asDictionary;
		  samples: samples;
		  yourself
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
AllocationGraph >> samples: aCollection [

	samples := aCollection
]

{ #category : 'api' }
AllocationGraph >> setUpForSamples: aCollection [

	samples := aCollection.
	aCollection do: [ :sample | self accumulateSample: sample ]
]

{ #category : 'api' }
AllocationGraph >> subGraphForType: aClass [

	^ self class onSamples: (samples select: [ :e | e allocatedObjectClass = aClass ])
]
