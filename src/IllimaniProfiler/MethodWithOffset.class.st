Class {
	#name : 'MethodWithOffset',
	#superclass : 'Object',
	#instVars : [
		'offset',
		'compiledMethodOrBlock'
	],
	#category : 'SendersChainTransformer-Core',
	#package : 'SendersChainTransformer',
	#tag : 'Core'
}

{ #category : 'instance creation' }
MethodWithOffset class >> method: aCompiledMethod offset: anInteger [

	^ self new
		  method: aCompiledMethod;
		  offset: anInteger;
		  yourself
]

{ #category : 'comparing' }
MethodWithOffset >> = anObj [

	self class = anObj class ifFalse: [ ^ false ].
	^ compiledMethodOrBlock = anObj method and: [ offset = anObj offset ]
]

{ #category : 'accessing' }
MethodWithOffset >> bytecode [

	^ compiledMethodOrBlock at: offset
]

{ #category : 'comparing' }
MethodWithOffset >> hash [

	| hash |
	hash := compiledMethodOrBlock hash.
	hash := hash * 486187739 + offset hash.
	^ hash
]

{ #category : 'inspector' }
MethodWithOffset >> inspector: aBuilder [

	<inspectorPresentationOrder: 0 title: 'Method code'>
	^ self inspectorPresenter
]

{ #category : 'inspector' }
MethodWithOffset >> inspectorPresenter [

	| interval |
	interval := (compiledMethodOrBlock sourceNode sourceNodeForPC: offset) sourceInterval.
	^ SpCodePresenter new
		  beForBehavior: compiledMethodOrBlock methodClass;
		  text: compiledMethodOrBlock sourceCode;
		  addTextSegmentDecoration: (SpTextPresenterDecorator forHighlight
				   interval: (interval first to: interval last + 1);
				   yourself);
		  beNotEditable;
		  yourself
]

{ #category : 'accessing' }
MethodWithOffset >> method [

	^ compiledMethodOrBlock
]

{ #category : 'accessing' }
MethodWithOffset >> method: aCompiledCode [

	compiledMethodOrBlock := aCompiledCode
]

{ #category : 'accessing' }
MethodWithOffset >> methodClass [

	^ compiledMethodOrBlock methodClass
]

{ #category : 'accessing' }
MethodWithOffset >> name [
	"Double method due to blocks"

	^ compiledMethodOrBlock method name
]

{ #category : 'accessing' }
MethodWithOffset >> offset [

	^ offset
]

{ #category : 'accessing' }
MethodWithOffset >> offset: anInt [

	offset := anInt
]

{ #category : 'accessing' }
MethodWithOffset >> parseTree [

	^ compiledMethodOrBlock method parseTree
]

{ #category : 'printing' }
MethodWithOffset >> printOn: aStream [

	compiledMethodOrBlock printOn: aStream.
	aStream << ' offset '.
	offset printOn: aStream
]

{ #category : 'accessing' }
MethodWithOffset >> selector [

	^ compiledMethodOrBlock selector
]
