Class {
	#name : #MpObjectAllocationProfilerHandler,
	#superclass : #MpHandler,
	#instVars : [
		'allocations',
		'classesToAvoid'
	],
	#category : #MethodProxiesSebas
}

{ #category : #evaluating }
MpObjectAllocationProfilerHandler >> afterExecutionWithReceiver: receiver arguments: arguments returnValue: returnValue [

	returnValue class = self classToRegister ifTrue: [ 
		allocations add:
			(MpInformationHolder
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
MpObjectAllocationProfilerHandler >> inspectorBarChartClassesContext: aContext [

	aContext withoutEvaluator
]

{ #category : #'inspector tabs' }
MpObjectAllocationProfilerHandler >> inspectorBarChartTopClasses [

	<inspectorPresentationOrder: 0 title: 'Top Classes Bar Chart'>
	^ SpRoassalPresenter new
		canvas: (SebasVisualizations new
			allocations: self allocations;
			barChartTopClassesCanvas);
		yourself
]

{ #category : #'inspector tabs' }
MpObjectAllocationProfilerHandler >> inspectorBarChartTopClassesContext: aContext [

	aContext withoutEvaluator
]

{ #category : #'inspector tabs' }
MpObjectAllocationProfilerHandler >> inspectorBarChartTopMethods [

	<inspectorPresentationOrder: 0 title: 'Top Methods Bar Chart'>
	^ SpRoassalPresenter new
		canvas: (SebasVisualizations new
			allocations: self allocations;
			barChartTopMethodsCanvas);
		yourself
]

{ #category : #'inspector tabs' }
MpObjectAllocationProfilerHandler >> inspectorBarChartTopMethodsContext: aContext [

	aContext withoutEvaluator
]

{ #category : #'inspector tabs' }
MpObjectAllocationProfilerHandler >> inspectorLineChart [

	<inspectorPresentationOrder: 0 title: 'Line Chart'>
	^ SpRoassalPresenter new
		canvas: (SebasVisualizations new
			allocations: self allocations;
			lineChartCanvas);
		yourself
]

{ #category : #'inspector tabs' }
MpObjectAllocationProfilerHandler >> inspectorLineChartContext: aContext [

	aContext withoutEvaluator
]

{ #category : #'inspector tabs' }
MpObjectAllocationProfilerHandler >> inspectorLineChartTopClasses [

	<inspectorPresentationOrder: 0 title: 'Line Chart Top Classes'>
	^ SpRoassalPresenter new
		canvas: (SebasVisualizations new
			allocations: self allocations;
			lineChartTopClassesCanvas);
		yourself
]

{ #category : #'inspector tabs' }
MpObjectAllocationProfilerHandler >> inspectorLineChartTopClassesContext: aContext [

	aContext withoutEvaluator
]

{ #category : #'inspector tabs' }
MpObjectAllocationProfilerHandler >> inspectorStats [

	<inspectorPresentationOrder: 0 title: 'Stats'>
	^ ObjecInstantiationStatsPresenter on: allocations
]

{ #category : #accessing }
MpObjectAllocationProfilerHandler >> statsString [

	^ (ObjecInstantiationStatsPresenter on: allocations) asString
]
