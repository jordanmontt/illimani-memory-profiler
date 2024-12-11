Class {
	#name : 'IllRewriterMethodWithBytecode',
	#superclass : 'Object',
	#instVars : [
		'method',
		'bytecode'
	],
	#category : 'IllimaniProfiler-Experiment',
	#package : 'IllimaniProfiler-Experiment'
}

{ #category : 'as yet unclassified' }
IllRewriterMethodWithBytecode class >> method: aCompiledMethod bytecode: anInteger [

	^ self new
		  method: aCompiledMethod;
		  bytecode: anInteger;
		  yourself
]

{ #category : 'accessing' }
IllRewriterMethodWithBytecode >> bytecode [
	^ bytecode
]

{ #category : 'accessing' }
IllRewriterMethodWithBytecode >> bytecode: anInteger [

	bytecode := anInteger
]

{ #category : 'accessing' }
IllRewriterMethodWithBytecode >> method [
	^ method
]

{ #category : 'accessing' }
IllRewriterMethodWithBytecode >> method: aCompiledMethod [

	method := aCompiledMethod
]
