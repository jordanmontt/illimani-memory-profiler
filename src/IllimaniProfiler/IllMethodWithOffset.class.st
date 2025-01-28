Class {
	#name : 'IllMethodWithOffset',
	#superclass : 'Object',
	#instVars : [
		'offset',
		'compiledMethodOrBlock'
	],
	#category : 'IllimaniProfiler-Inspector-Utilities',
	#package : 'IllimaniProfiler',
	#tag : 'Inspector-Utilities'
}

{ #category : 'instance creation' }
IllMethodWithOffset class >> method: aCompiledMethod offset: anInteger [

	^ self new
		  method: aCompiledMethod;
		  offset: anInteger;
		  yourself
]

{ #category : 'comparing' }
IllMethodWithOffset >> = anObj [

	self class = anObj class ifFalse: [ ^ false ].
	^ compiledMethodOrBlock = anObj method and: [ offset = anObj offset ]
]

{ #category : 'accessing' }
IllMethodWithOffset >> bytecode [

	^ compiledMethodOrBlock at: offset
]

{ #category : 'comparing' }
IllMethodWithOffset >> hash [

	| hash |
	hash := compiledMethodOrBlock hash.
	hash := hash * 486187739 + offset hash.
	^ hash
]

{ #category : 'inspector' }
IllMethodWithOffset >> inspector: aBuilder [

	<inspectorPresentationOrder: 0 title: 'Method code'>
	^ self inspectorPresenter
]

{ #category : 'inspector' }
IllMethodWithOffset >> inspectorPresenter [

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
IllMethodWithOffset >> method [

	^ compiledMethodOrBlock
]

{ #category : 'accessing' }
IllMethodWithOffset >> method: aCompiledCode [

	compiledMethodOrBlock := aCompiledCode
]

{ #category : 'accessing' }
IllMethodWithOffset >> methodClass [

	^ compiledMethodOrBlock methodClass
]

{ #category : 'accessing' }
IllMethodWithOffset >> name [
	"Double method due to blocks"

	^ compiledMethodOrBlock method name
]

{ #category : 'accessing' }
IllMethodWithOffset >> offset [

	^ offset
]

{ #category : 'accessing' }
IllMethodWithOffset >> offset: anInt [

	offset := anInt
]

{ #category : 'accessing' }
IllMethodWithOffset >> parseTree [

	^ compiledMethodOrBlock method parseTree
]

{ #category : 'printing' }
IllMethodWithOffset >> printOn: aStream [

	compiledMethodOrBlock printOn: aStream.
	aStream << ' offset '.
	offset printOn: aStream
]

{ #category : 'accessing' }
IllMethodWithOffset >> selector [

	^ compiledMethodOrBlock selector
]
