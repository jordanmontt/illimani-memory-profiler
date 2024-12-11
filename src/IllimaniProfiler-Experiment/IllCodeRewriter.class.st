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
1halt.
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

	| selectorToReplace newSelector irSendNode ir irSequences |
	selectorToReplace := (compiledMethod sourceNode sourceNodeForPC: offset)
		                     selector.
	newSelector := self tenureSelector: selectorToReplace.

	ir := compiledMethod decompileIR.
	1 halt.
	irSequences := ir allSequences flatCollect: #children.
	irSendNode := (irSequences select: #isSend) detect: [ :e | e selector = selectorToReplace ].
	irSendNode selector: newSelector.

	^ ir compiledMethod
]

{ #category : 'private' }
IllCodeRewriter >> tenureSelector: aByteSymbol [

	aByteSymbol = #new ifTrue: [ ^ #newTenured ].
	aByteSymbol = #new: ifTrue: [ ^ #newTenured: ].
	aByteSymbol = #basicNew ifTrue: [ ^ #basicNewTenured ].
	aByteSymbol = #basicNew: ifTrue: [ ^ #basicNewTenured: ].
	^ self defaultTenureSelector: aByteSymbol
]
