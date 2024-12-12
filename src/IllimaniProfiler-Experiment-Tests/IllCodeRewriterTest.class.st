"
An IllRewriterTest is a test class for testing the behavior of IllRewriter
"
Class {
	#name : 'IllCodeRewriterTest',
	#superclass : 'TestCase',
	#instVars : [
		'rewriter',
		'senders',
		'basicNewAllocationSite',
		'initialCaller'
	],
	#category : 'IllimaniProfiler-Experiment-Tests',
	#package : 'IllimaniProfiler-Experiment-Tests'
}

{ #category : 'running' }
IllCodeRewriterTest >> setUp [

	super setUp.

	rewriter := IllCodeRewriter new.
	initialCaller := IllRewriterMethodWithBytecode method: IllFakeClass >> #foo offset: 45.
	senders := {
		           (IllRewriterMethodWithBytecode method: IllAnotherFakeClass >> #bar offset: 36).
		           (IllRewriterMethodWithBytecode method: Dictionary >> #at:put: offset: 82).
		           (IllRewriterMethodWithBytecode method: Association class >> #key:value: offset: 42) }.

	rewriter storeBackupSenders: senders caller: initialCaller
]

{ #category : 'running' }
IllCodeRewriterTest >> tearDown [

	rewriter restoreMethodsToOriginalState.
	senders do: [ :illSender |
		illSender method methodClass removeSelector: (rewriter tenureSelector: illSender selector) ].

	super tearDown
]

{ #category : 'tests' }
IllCodeRewriterTest >> testCloneMethodWithTenureSelector [

	| illSender tenuredNewSelector clonedCompiledMethod |
	illSender := senders first.
	tenuredNewSelector := rewriter tenureSelector: #bar.

	"Method does not exist yet"
	self should: [ IllAnotherFakeClass new perform: tenuredNewSelector ] raise: MessageNotUnderstood.
	self deny: (IllAnotherFakeClass includesSelector: tenuredNewSelector).

	"Clone method with a different selector"
	clonedCompiledMethod := rewriter cloneMethodWithTenureSelector: illSender.
	rewriter installMethod: clonedCompiledMethod.

	self shouldnt: [ IllAnotherFakeClass new perform: tenuredNewSelector ] raise: MessageNotUnderstood.
	self assert: clonedCompiledMethod selector equals: tenuredNewSelector.
	self assert: (IllAnotherFakeClass includesSelector: tenuredNewSelector).
	self assert: (IllAnotherFakeClass methodDict at: tenuredNewSelector) equals: clonedCompiledMethod.

	"Cloned method should have the same code but a different selector"
	self assert: clonedCompiledMethod bytecodes equals: illSender method bytecodes.
	self deny: clonedCompiledMethod selector equals: illSender method selector
]

{ #category : 'tests' }
IllCodeRewriterTest >> testTenureCallingSendersInitialCaller [
	"Methods do not exist"

	self should: [ IllAnotherFakeClass new perform: (rewriter tenureSelector: #bar) ] raise: MessageNotUnderstood.
	self
		should: [ Dictionary new perform: (rewriter tenureSelector: #at:put:) withArguments: #( #key 2 ) ]
		raise: MessageNotUnderstood.
	self
		should: [ Association perform: (rewriter tenureSelector: #key:value:) withArguments: #( #key #value ) ]
		raise: MessageNotUnderstood.

	rewriter tenureCallingSenders: senders initialCaller: initialCaller.

	self shouldnt: [ IllAnotherFakeClass new perform: (rewriter tenureSelector: #bar) ] raise: MessageNotUnderstood.
	self
		shouldnt: [ Dictionary new perform: (rewriter tenureSelector: #at:put:) withArguments: #( #key 2 ) ]
		raise: MessageNotUnderstood.
	self
		shouldnt: [ Association perform: (rewriter tenureSelector: #key:value:) withArguments: #( #key #value ) ]
		raise: MessageNotUnderstood
]

{ #category : 'tests' }
IllCodeRewriterTest >> testTenureMessageSendForOffset [

	| illSender tenuredCompiledMethod symbolicMessageSendBytecode expectedSelector offset methodToTenure |
	illSender := senders second. "Dictionary >> #at:put:"
	methodToTenure := illSender method.
	offset := illSender offset.
	expectedSelector := rewriter tenureSelector: (illSender method sourceNodeForPC: offset) selector.

	self
		shouldnt: [ methodToTenure valueWithReceiver: methodToTenure methodClass new arguments: #( #key #value ) ]
		raise: PrimitiveFailed.

	tenuredCompiledMethod := rewriter tenureMessageSendFor: methodToTenure clone offset: offset.

	symbolicMessageSendBytecode := tenuredCompiledMethod symbolicBytecodes detect: [ :e |
		                               e bytes includes: illSender bytecode ].
	self assert: symbolicMessageSendBytecode description equals: 'send: ' , expectedSelector.
	"Method's selector remaine unchanged"
	self assert: tenuredCompiledMethod selector equals: illSender selector.
	"We pretenure one message send to a method that does not exists"
	self
		should: [ tenuredCompiledMethod valueWithReceiver: methodToTenure methodClass new arguments: #( #key #value ) ]
		raise: MessageNotUnderstood
]
