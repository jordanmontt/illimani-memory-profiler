Class {
	#name : 'MethodWithOffset',
	#superclass : 'Object',
	#instVars : [
		'method',
		'offset'
	],
	#category : 'IllimaniProfiler-Profiler',
	#package : 'IllimaniProfiler',
	#tag : 'Profiler'
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
	^ method = anObj method and: [ offset = anObj offset ]
]

{ #category : 'accessing' }
MethodWithOffset >> bytecode [

	^ method at: offset
]

{ #category : 'comparing' }
MethodWithOffset >> hash [

	| hash |
	hash := method hash.
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
	interval := (method sourceNode sourceNodeForPC: offset) sourceInterval.
	^ SpCodePresenter new
		  beForBehavior: method methodClass;
		  text: method sourceCode;
		  addTextSegmentDecoration: (SpTextPresenterDecorator forHighlight
				   interval: (interval first to: interval last + 1);
				   yourself);
		  beNotEditable;
		  yourself
]

{ #category : 'accessing' }
MethodWithOffset >> method [

	^ method
]

{ #category : 'accessing' }
MethodWithOffset >> method: aCompiledMethod [

	method := aCompiledMethod
]

{ #category : 'accessing' }
MethodWithOffset >> offset [

	^ offset
]

{ #category : 'accessing' }
MethodWithOffset >> offset: anInt [

	offset := anInt
]

{ #category : 'printing' }
MethodWithOffset >> printOn: aStream [

	method printOn: aStream.
	aStream << ' offset '.
	offset printOn: aStream
]

{ #category : 'accessing' }
MethodWithOffset >> selector [

	^ method selector
]
