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

{ #category : 'as yet unclassified' }
IllPretenurator >> doMagic: toPretenureSites [

	toPretenureSites do: [ :allocationSenders |
		| sct allocationSenders initialCaller sendersToTransform |
		initialCaller := allocationSenders last.
		sendersToTransform := allocationSenders allButLast.
		
		sct := SendersChainTransformer new.
		codeTransformers add: sct.
		sct backupSenders: sendersToTransform caller: initialCaller.
		sct transformCallingSenders: sendersToTransform initialCaller: initialCaller ]
]

{ #category : 'initialization' }
IllPretenurator >> initialize [

	super initialize.
	codeTransformers := OrderedCollection new
]

{ #category : 'as yet unclassified' }
IllPretenurator >> restoreOriginalState [

	codeTransformers do: #restoreOriginalState
]
