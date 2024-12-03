Class {
	#name : 'IllMethodHighlightedBytecodePresenterInspection',
	#superclass : 'Object',
	#instVars : [
		'method',
		'offset'
	],
	#category : 'IllimaniProfiler-Profiler',
	#package : 'IllimaniProfiler',
	#tag : 'Profiler'
}

{ #category : 'as yet unclassified' }
IllMethodHighlightedBytecodePresenterInspection >> buildPresenter [

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

{ #category : 'as yet unclassified' }
IllMethodHighlightedBytecodePresenterInspection >> inspector: aBuilder [

	<inspectorPresentationOrder: 2 title: 'Senders call stack'>
	^ self buildPresenter
]

{ #category : 'as yet unclassified' }
IllMethodHighlightedBytecodePresenterInspection >> method: aMethod [

	method := aMethod
]

{ #category : 'as yet unclassified' }
IllMethodHighlightedBytecodePresenterInspection >> offset: anOffset [

	offset := anOffset
]
