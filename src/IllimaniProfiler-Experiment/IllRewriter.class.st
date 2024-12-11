Class {
	#name : 'IllRewriter',
	#superclass : 'Object',
	#category : 'IllimaniProfiler-Experiment',
	#package : 'IllimaniProfiler-Experiment'
}

{ #category : 'as yet unclassified' }
IllRewriter >> cloneWithPretenuringSelector: anIllSender [

	| compiledMethod newSelector |
	compiledMethod := anIllSender method copy.
	newSelector := self pretenuredSelector: compiledMethod selector.
	
	compiledMethod selector: newSelector.
	compiledMethod sourceNode selector: newSelector.
	1 halt.
	
	compiledMethod methodClass methodDict at: newSelector put: compiledMethod.

	^ compiledMethod
]

{ #category : 'as yet unclassified' }
IllRewriter >> pretenuredSelector: aByteSymbol [

	^ #_pretenured_ , aByteSymbol
]

{ #category : 'as yet unclassified' }
IllRewriter >> rewriteForPretenuring: senders inBasicNewCaller: basicNewAllocSite [

	| isFirst compiledMethod |
	isFirst := true.
	senders do: [ :aSender |
		compiledMethod := isFirst
			ifTrue: [ aSender method ]
			ifFalse: [ self cloneWithPretenuringSelector: aSender ].

		self tenureMessageSendForCompiledMethod: compiledMethod offset: aSender bytecode.
		compiledMethod recompile.
		1 halt.
		isFirst := false ]
	
]

{ #category : 'as yet unclassified' }
IllRewriter >> rewriteSelector: aByteSymbol [

	aByteSymbol = #new ifTrue: [ ^ #newTenured ].
	aByteSymbol = #new: ifTrue: [ ^ #newTenured: ].
	aByteSymbol = #basicNew ifTrue: [ ^ #basicNewTenured ].
	aByteSymbol = #basicNew: ifTrue: [ ^ #basicNewTenured: ].
	^ self pretenuredSelector: aByteSymbol
]

{ #category : 'as yet unclassified' }
IllRewriter >> tenureMessageSendForCompiledMethod: compiledMethod offset: bytecode [

	| messageSendNode |
	messageSendNode := compiledMethod sourceNode sourceNodeForPC:	bytecode.
	messageSendNode selector: (self rewriteSelector: messageSendNode selector)
]
