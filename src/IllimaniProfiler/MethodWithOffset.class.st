Class {
	#name : 'MethodWithOffset',
	#superclass : 'Object',
	#instVars : [
		'method',
		'offset'
	],
	#category : 'IllimaniProfiler-Inspector-Utilities',
	#package : 'IllimaniProfiler',
	#tag : 'Inspector-Utilities'
}

{ #category : 'instance creation' }
MethodWithOffset class >> method: aCompiledMethod offset: anInteger [

	^ self new
		  method: aCompiledMethod;
		  offset: anInteger;
		  yourself
]

{ #category : 'inspector' }
MethodWithOffset >> buildPresenter [

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
MethodWithOffset >> bytecode [

	^ method at: offset
]

{ #category : 'inspector' }
MethodWithOffset >> inspector: aBuilder [

	<inspectorPresentationOrder: 0 title: 'Method code'>
	^ self buildPresenter
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

	aStream << method name << ' offset '.
	offset printOn: aStream
]

{ #category : 'accessing' }
MethodWithOffset >> selector [

	^ method selector
]
