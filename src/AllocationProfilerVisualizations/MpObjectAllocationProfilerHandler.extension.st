Extension { #name : #MpObjectAllocationProfilerHandler }

{ #category : #'*AllocationProfilerVisualizations' }
MpObjectAllocationProfilerHandler >> inspectorBarChartClasses [

	"<inspectorPresentationOrder: 0 title: 'Classes Bar Chart'>"
	^ SpRoassalPresenter new
		canvas: (AllocationVisualizations new
			statsModel: self stats;
			barChartClassesCanvas);
		yourself
]

{ #category : #'*AllocationProfilerVisualizations' }
MpObjectAllocationProfilerHandler >> inspectorGeneralStats [

	<inspectorPresentationOrder: 0 title: 'General Stats'>
	^ ObjectAllocationStatsPresenter on: self stats
]

{ #category : #'*AllocationProfilerVisualizations' }
MpObjectAllocationProfilerHandler >> inspectorNumberOfAllocatedObjectsPerSecond [

	<inspectorPresentationOrder: 1 title: 'Allocated Objects per Second'>
	^ SpRoassalPresenter new
		canvas: (AllocationVisualizations new
			statsModel: self stats;
			allocatedObjectsPerSecondLineChartCanvas);
		yourself
]

{ #category : #'*AllocationProfilerVisualizations' }
MpObjectAllocationProfilerHandler >> inspectorNumberOfAllocatedObjectsPerSecondContext: aContext [

	aContext withoutEvaluator
]

{ #category : #'*AllocationProfilerVisualizations' }
MpObjectAllocationProfilerHandler >> inspectorNumberOfAllocatedObjectsPerSecondPerClass [

	<inspectorPresentationOrder: 2 title: 'Allocated Objects per Second per Class'>
	^ SpRoassalPresenter new
		canvas: (AllocationVisualizations new
			statsModel: self stats;
			allocatedObjectsPerSecondPerClassLineChartCanvas);
		yourself
]

{ #category : #'*AllocationProfilerVisualizations' }
MpObjectAllocationProfilerHandler >> inspectorNumberOfAllocatedObjectsPerSecondPerClassContext: aContext [

	aContext withoutEvaluator
]

{ #category : #'*AllocationProfilerVisualizations' }
MpObjectAllocationProfilerHandler >> inspectorTopClassesThatAllocateObjects [

	<inspectorPresentationOrder: 4 title: 'Top Allocator Classes'>
	^ SpRoassalPresenter new
		canvas: (AllocationVisualizations new
			statsModel: self stats;
			topClassesThatAllocateObjectsBarChartCanvas);
		yourself
]

{ #category : #'*AllocationProfilerVisualizations' }
MpObjectAllocationProfilerHandler >> inspectorTopClassesThatAllocateObjectsContext: aContext [

	aContext withoutEvaluator
]

{ #category : #'*AllocationProfilerVisualizations' }
MpObjectAllocationProfilerHandler >> inspectorTopMethodsThatAllocateObjects [

	<inspectorPresentationOrder: 3 title: 'Top Allocator Methods'>
	^ SpRoassalPresenter new
		canvas: (AllocationVisualizations new
			statsModel: self stats;
			topMethodsThatAllocateObjectsBarChartCanvas);
		yourself
]

{ #category : #'*AllocationProfilerVisualizations' }
MpObjectAllocationProfilerHandler >> inspectorTopMethodsThatAllocateObjectsContext: aContext [

	aContext withoutEvaluator
]
