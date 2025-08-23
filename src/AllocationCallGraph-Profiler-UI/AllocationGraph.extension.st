Extension { #name : 'AllocationGraph' }

{ #category : '*AllocationCallGraph-Profiler-UI' }
AllocationGraph >> inspectGraph: aBuilder [

	<inspectorPresentationOrder: 1 title: 'Graph'>
	^ AllocationGraphVizu new buildInspectorPresenterFor: self withBuilder: aBuilder
]

{ #category : '*AllocationCallGraph-Profiler-UI' }
AllocationGraph >> inspectGraphContext: aContext [

	aContext withoutEvaluator
]
