Class {
	#name : 'IllPretenurator',
	#superclass : 'Object',
	#instVars : [
		'codeTransformers'
	],
	#category : 'IllimaniProfiler-Analyzer',
	#package : 'IllimaniProfiler',
	#tag : 'Analyzer'
}

{ #category : 'initialization' }
IllPretenurator >> initialize [

	super initialize.
	codeTransformers := OrderedCollection new
]

{ #category : 'api' }
IllPretenurator >> pretenureAllocationChainForInitialCaller: initialCaller senders: sendersToTransform [

	| sct |
	sct := SendersChainTransformer new.
	codeTransformers add: sct.
	sct backupSenders: sendersToTransform caller: initialCaller.
	sct transformCallingSenders: sendersToTransform initialCaller: initialCaller
]

{ #category : 'api' }
IllPretenurator >> pretenureAllocations: toPretenureSitesArray [

	toPretenureSitesArray do: [ :methodsWithOffsets |
		self pretenureAllocationChainForInitialCaller: methodsWithOffsets last senders: methodsWithOffsets allButLast ]
]

{ #category : 'api' }
IllPretenurator >> restoreOriginalState [

	codeTransformers do: #restoreOriginalState
]
