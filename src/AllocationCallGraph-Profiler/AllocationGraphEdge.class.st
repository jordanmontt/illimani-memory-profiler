Class {
	#name : 'AllocationGraphEdge',
	#superclass : 'AllocationGraphComponent',
	#instVars : [
		'offset',
		'allocNodeStatistics',
		'targetNode',
		'sourceNode'
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
    | layout |
    layout := SpBoxLayout newTopToBottom
        spacing: 3;
        add: (aBuilder newText text: 'Source Node: ' , sourceNode method method name, ' offset: ', offset asString;
                yourself)
        expand: false;
        add: ((IllMethodWithOffset method: sourceNode method offset: offset)
                inspectorPresenter: aBuilder);
        add: (aBuilder newText text: 'Target Node: ', targetNode method method name; yourself)
        expand: false;
        add: (targetNode method inspectionSource: aBuilder);
        yourself.
	^ aBuilder newPresenter
		layout: layout;
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
