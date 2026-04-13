Class {
	#name : 'AllocationGraphEdge',
	#superclass : 'AllocationGraphComponent',
	#instVars : [
		'offset',
		'allocNodeStatistics',
		'targetNode',
		'sourceNode',
		'allocatedObjectTypes'
	],
	#category : 'AllocationCallGraph-Profiler-AllocationCallGraph',
	#package : 'AllocationCallGraph-Profiler',
	#tag : 'AllocationCallGraph'
}

{ #category : 'accessing' }
AllocationGraphEdge class >> targetNode: node sourceNode: aSourceNode offset: anInteger [

	^ self new
		  targetNode: node;
		  sourceNode: aSourceNode;
		  offset: anInteger;
		  yourself
]

{ #category : 'accessing' }
AllocationGraphEdge >> allocatedObjectTypes [

	^ allocatedObjectTypes ifNil: [
		  allocatedObjectTypes := self allocatedSamples collect: #allocatedObjectClass as: Set ]
]

{ #category : 'accessing' }
AllocationGraphEdge >> allocatedSamples [

	^ allocNodeStatistics allocatedSamples
]

{ #category : 'initialization' }
AllocationGraphEdge >> initialize [

	super initialize.
	allocNodeStatistics := AllocationGraphStats new
]

{ #category : 'accessing' }
AllocationGraphEdge >> inspectorMethodWithOffset: aBuilder [

    <inspectorPresentationOrder: 0 title: 'Edge'>
    | text spaces |
    spaces := {sourceNode method printString size . targetNode method printString size } average.
    spaces := spaces asInteger.

    text := String streamContents: [ :stream |
        sourceNode method printOn: stream.
        stream << ' (offset '.
        offset printOn: stream.
        stream << ')' << String cr.
        spaces timesRepeat: [ stream << String space ].
        stream << '-->' << String cr.
        targetNode method printOn: stream ].

    ^ aBuilder newPresenter
        layout: (SpBoxLayout newTopToBottom
            spacing: 3;
            add: (aBuilder newText text: text; yourself) height: 70;
            add: ((IllMethodWithOffset method: sourceNode method offset: offset)
                    inspectorPresenter: aBuilder));
            yourself
]

{ #category : 'accessing' }
AllocationGraphEdge >> offset [
	^ offset
]

{ #category : 'accessing' }
AllocationGraphEdge >> offset: anInteger [

	offset := anInteger
]

{ #category : 'printing' }
AllocationGraphEdge >> printOn: aStream [

	aStream
		nextPutAll: sourceNode method selector;
		nextPutAll: ' -> ';
		nextPutAll: targetNode method selector;
		nextPutAll: ' weight ';
		print: self allocatedSamples size
]

{ #category : 'accessing' }
AllocationGraphEdge >> sourceNode [

	^ sourceNode
]

{ #category : 'accessing' }
AllocationGraphEdge >> sourceNode: anAllocationGraphNode [

	sourceNode := anAllocationGraphNode
]

{ #category : 'accessing' }
AllocationGraphEdge >> targetNode [

	^ targetNode
]

{ #category : 'accessing' }
AllocationGraphEdge >> targetNode: anObject [

	targetNode := anObject
]

{ #category : 'api' }
AllocationGraphEdge >> updateFromSample: aSample [

	allocNodeStatistics updateFromSample: aSample
]
