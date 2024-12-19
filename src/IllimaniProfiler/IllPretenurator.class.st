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

	[
	toPretenureSites valuesDo: [ :allocSiteBin |
		| sct allocationSenders initialCaller sendersToTransform |
		allocationSenders := (allocSiteBin allObjects collect: #allocationSenders as: Set) anyOne
			                     asMethodWithOffsetObjects.
		initialCaller := allocationSenders last.
		sendersToTransform := allocationSenders allButLast.

		sct := SendersChainTransformer new.
		codeTransformers add: sct.
		sct backupSenders: sendersToTransform caller: initialCaller.
		sct transformCallingSenders: sendersToTransform initialCaller: initialCaller ] ]

	ensure: [ codeTransformers do: #restoreOriginalState ]
]

{ #category : 'initialization' }
IllPretenurator >> initialize [

	super initialize.
	codeTransformers := OrderedCollection new
]
