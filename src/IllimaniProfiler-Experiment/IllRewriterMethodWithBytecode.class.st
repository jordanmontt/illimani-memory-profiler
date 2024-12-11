Class {
	#name : 'IllRewriterMethodWithBytecode',
	#superclass : 'Object',
	#instVars : [
		'method',
		'offset'
	],
	#category : 'IllimaniProfiler-Experiment',
	#package : 'IllimaniProfiler-Experiment'
}

{ #category : 'instance creation' }
IllRewriterMethodWithBytecode class >> method: aCompiledMethod offset: anInteger [

	^ self new
		  method: aCompiledMethod;
		  offset: anInteger;
		  yourself
]

{ #category : 'accessing' }
IllRewriterMethodWithBytecode >> bytecode [

	^ method at: offset
]

{ #category : 'accessing' }
IllRewriterMethodWithBytecode >> method [

	^ method
]

{ #category : 'accessing' }
IllRewriterMethodWithBytecode >> method: aCompiledMethod [

	method := aCompiledMethod
]

{ #category : 'accessing' }
IllRewriterMethodWithBytecode >> offset [

	^ offset
]

{ #category : 'accessing' }
IllRewriterMethodWithBytecode >> offset: anInt [

	offset := anInt
]

{ #category : 'accessing' }
IllRewriterMethodWithBytecode >> selector [

	^ method selector
]
