Class {
	#name : 'IllCodeRewriter',
	#superclass : 'Object',
	#instVars : [
		'originalCaller',
		'originalSenders'
	],
	#category : 'IllimaniProfiler-Experiment',
	#package : 'IllimaniProfiler-Experiment'
}

{ #category : 'private' }
IllCodeRewriter >> cloneMethodWithTenureSelector: anIllSender [

	| compiledMethod newSelector |
	compiledMethod := anIllSender method copy.
	newSelector := self defaultTenureSelector: compiledMethod selector.

	compiledMethod selector: newSelector.

	^ compiledMethod
]

{ #category : 'private' }
IllCodeRewriter >> defaultTenureSelector: aByteSymbol [

	^ #_pretenured_ , aByteSymbol
]

{ #category : 'private' }
IllCodeRewriter >> installMethod: aCompiledMethod [

	aCompiledMethod methodClass methodDict at: aCompiledMethod selector put: aCompiledMethod
]

{ #category : 'api' }
IllCodeRewriter >> restoreMethodsToOriginalState [

	self installMethod: originalCaller.
	originalSenders do: [ :aCompiledMethod | self installMethod: aCompiledMethod ]
]

{ #category : 'private' }
IllCodeRewriter >> storeBackupSenders: senders caller: initialCaller [

	originalCaller := initialCaller method copy.
	originalSenders := senders collect: [ :illSender | illSender method copy ]
]

{ #category : 'api' }
IllCodeRewriter >> tenureCallingSenders: senders initialCaller: initialCaller [

	| compiledMethod |
	self storeBackupSenders: senders caller: initialCaller.

	initialCaller method methodClass methodDict
		at: initialCaller selector
		put: (self tenureMessageSendFor: initialCaller method offset: initialCaller offset).

	senders do: [ :anIllSender |
		compiledMethod := self cloneMethodWithTenureSelector: anIllSender.
		compiledMethod := self tenureMessageSendFor: compiledMethod offset: anIllSender offset.
		self installMethod: compiledMethod ]
]

{ #category : 'private' }
IllCodeRewriter >> tenureMessageSendFor: compiledMethod offset: offset [

	| messageSendSelector newMessageSendSelector irSendNode ir irSequences newCompiledMethod |
	messageSendSelector := (compiledMethod sourceNode sourceNodeForPC: offset) selector.
	newMessageSendSelector := self tenureSelector: messageSendSelector.

	ir := compiledMethod ir.
	irSequences := ir allSequences flatCollect: #children.
	irSendNode := (irSequences select: #isSend) detect: [ :e | e selector = messageSendSelector ].
	irSendNode selector: newMessageSendSelector.

	newMessageSendSelector := ir generate selector: compiledMethod selector; yourself.
	^ newMessageSendSelector
]

{ #category : 'private' }
IllCodeRewriter >> tenureSelector: aByteSymbol [

	aByteSymbol = #new ifTrue: [ ^ #newTenured ].
	aByteSymbol = #new: ifTrue: [ ^ #newTenured: ].
	aByteSymbol = #basicNew ifTrue: [ ^ #basicNewTenured ].
	aByteSymbol = #basicNew: ifTrue: [ ^ #basicNewTenured: ].
	^ self defaultTenureSelector: aByteSymbol
]
