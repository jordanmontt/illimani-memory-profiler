"
An IllRewriterTest is a test class for testing the behavior of IllRewriter
"
Class {
	#name : 'IllRewriterTest',
	#superclass : 'TestCase',
	#instVars : [
		'rewriter'
	],
	#category : 'IllimaniProfiler-Experiment-Tests',
	#package : 'IllimaniProfiler-Experiment-Tests'
}

{ #category : 'running' }
IllRewriterTest >> setUp [

	super setUp.

	rewriter := IllRewriter new
]

{ #category : 'as yet unclassified' }
IllRewriterTest >> testrRewrite [

	| senders basicNewAllocationSite |
	basicNewAllocationSite := IllRewriterMethodWithBytecode
		                          method: Association class >> #key:value:
		                          bytecode: 42.
	senders := {
		           (IllRewriterMethodWithBytecode
			            method: IllFakeClass >> #foo
			            bytecode: 45).
		           (IllRewriterMethodWithBytecode
			            method: IllAnotherTakeClass >> #bar
			            bytecode: 36).
		           (IllRewriterMethodWithBytecode
			            method: Dictionary >> #at:put:
			            bytecode: 82) }.
	rewriter rewriteForPretenuring: senders inBasicNewCaller: basicNewAllocationSite
]
