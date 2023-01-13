Class {
	#name : #MpObjectAllocationProfilerHandler,
	#superclass : #MpHandler,
	#instVars : [
		'allocations',
		'classesToAvoid'
	],
	#category : #AllocationProfiler
}

{ #category : #evaluating }
MpObjectAllocationProfilerHandler >> afterExecutionWithReceiver: receiver arguments: arguments returnValue: returnValue [

	returnValue class = self classToRegister ifTrue: [ 
		allocations add:
			(AllocationInformationHolder
				context: (self contextThatCreatesTheColor: thisContext) copyStack
				createdObject: returnValue) ].
	^ returnValue
]

{ #category : #accessing }
MpObjectAllocationProfilerHandler >> allocations [

	^ allocations
]

{ #category : #evaluating }
MpObjectAllocationProfilerHandler >> classToRegister [

	^ self subclassResponsibility
]

{ #category : #evaluating }
MpObjectAllocationProfilerHandler >> contextThatCreatesTheColor: aContext [

	"(classToAvoid includes: aContext sender methodClass) ifFalse: [ 
	^ aContext sender methodClass ].
	^ self classThatCreatesTheColor: aContext sender"

	| sender |
	sender := aContext sender.
	[ classesToAvoid includes: sender methodClass ] whileTrue: [ 
		sender := sender sender ].
	^ sender
]

{ #category : #initialization }
MpObjectAllocationProfilerHandler >> defaultClassesToAvoid [

	^{ 
		self class.
		MpMethodProxy.
		BlockClosure.
		FullBlockClosure.
		CompiledBlock }
]

{ #category : #initialization }
MpObjectAllocationProfilerHandler >> initialize [

	super initialize.
	allocations := OrderedCollection new.
	classesToAvoid := self defaultClassesToAvoid , { self classToRegister . self classToRegister class }
]

{ #category : #'inspector tabs' }
MpObjectAllocationProfilerHandler >> inspectorBarChartClasses [

	"<inspectorPresentationOrder: 0 title: 'Classes Bar Chart'>"
	^ SpRoassalPresenter new
		canvas: (SebasVisualizations new
			allocations: self allocations;
			barChartClassesCanvas);
		yourself
]

{ #category : #'inspector tabs' }
MpObjectAllocationProfilerHandler >> inspectorGeneralStats [

	<inspectorPresentationOrder: 0 title: 'General Stats'>
	^ ObjecAllocationStatsPresenter on: allocations
]

{ #category : #'inspector tabs' }
MpObjectAllocationProfilerHandler >> inspectorNumberOfAllocatedObjectsPerSecond [

	<inspectorPresentationOrder: 1 title: 'Number of Allocated Objects per Second'>
	^ SpRoassalPresenter new
		canvas: (SebasVisualizations new
			allocations: self allocations;
			numberOfAllocatedObjectsPerSecondLineChartCanvas);
		yourself
]

{ #category : #'inspector context' }
MpObjectAllocationProfilerHandler >> inspectorNumberOfAllocatedObjectsPerSecondContext: aContext [

	aContext withoutEvaluator
]

{ #category : #'inspector tabs' }
MpObjectAllocationProfilerHandler >> inspectorNumberOfAllocatedObjectsPerSecondPerClass [

	<inspectorPresentationOrder: 2 title: 'Number of Allocated Objects per Second per Class'>
	^ SpRoassalPresenter new
		canvas: (SebasVisualizations new
			allocations: self allocations;
			numberOfAllocatedObjectsPerSecondPerClassLineChartCanvas);
		yourself
]

{ #category : #'inspector context' }
MpObjectAllocationProfilerHandler >> inspectorNumberOfAllocatedObjectsPerSecondPerClassContext: aContext [

	aContext withoutEvaluator
]

{ #category : #'inspector tabs' }
MpObjectAllocationProfilerHandler >> inspectorTopClassesThatAllocateObjects [

	<inspectorPresentationOrder: 4 title: 'Top Classes That Allocate Objects'>
	^ SpRoassalPresenter new
		canvas: (SebasVisualizations new
			allocations: self allocations;
			topClassesThatAllocateObjectsBarChartCanvas);
		yourself
]

{ #category : #'inspector context' }
MpObjectAllocationProfilerHandler >> inspectorTopClassesThatAllocateObjectsContext: aContext [

	aContext withoutEvaluator
]

{ #category : #'inspector tabs' }
MpObjectAllocationProfilerHandler >> inspectorTopMethodsThatAllocateObjects [

	<inspectorPresentationOrder: 3 title: 'Top Methods That Allocate Objects'>
	^ SpRoassalPresenter new
		canvas: (SebasVisualizations new
			allocations: self allocations;
			topMethodsThatAllocateObjectsBarChartCanvas);
		yourself
]

{ #category : #'inspector context' }
MpObjectAllocationProfilerHandler >> inspectorTopMethodsThatAllocateObjectsContext: aContext [

	aContext withoutEvaluator
]

{ #category : #accessing }
MpObjectAllocationProfilerHandler >> statsString [

	^ (ObjecAllocationStatsPresenter on: allocations) asString
]
