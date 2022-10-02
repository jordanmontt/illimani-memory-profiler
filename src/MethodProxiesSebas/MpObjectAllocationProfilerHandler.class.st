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
				context: (self contextThatCreatesTheColor: thisContext)
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
MpObjectAllocationProfilerHandler >> customClassesToAvoid [

	^ self subclassResponsibility
]

{ #category : #initialization }
MpObjectAllocationProfilerHandler >> defaultClassesToAvoid [

	^{ 
		MpColorAllocationProfilerHandler.
		MpMethodProxy.
		BlockClosure.
		FullBlockClosure.
		CompiledBlock }
]

{ #category : #initialization }
MpObjectAllocationProfilerHandler >> initialize [

	super initialize.
	allocations := OrderedCollection new.
	classesToAvoid := self defaultClassesToAvoid , self customClassesToAvoid
]

{ #category : #'inspector tabs' }
MpObjectAllocationProfilerHandler >> inspectorBarChart [

	<inspectorPresentationOrder: 0 title: 'Bar Chart'>
	^ SpRoassalPresenter new
		canvas: (SebasVisualizations new
			allocations: self allocations;
			barChartCanvas);
		yourself
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
MpObjectAllocationProfilerHandler >> inspectorLineChartTopClasses [

	<inspectorPresentationOrder: 0 title: 'Line Chart Top Classes'>
	^ SpRoassalPresenter new
		canvas: (SebasVisualizations new
			allocations: self allocations;
			lineChartTopClassesCanvas);
		yourself
]
