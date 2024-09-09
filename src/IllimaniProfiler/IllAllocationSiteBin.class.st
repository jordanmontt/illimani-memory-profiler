Class {
	#name : 'IllAllocationSiteBin',
	#superclass : 'Object',
	#instVars : [
		'immortalObjects',
		'longLivedObjects',
		'shortLivedObjects',
		'classification'
	],
	#category : 'IllimaniProfiler-Analyzer',
	#package : 'IllimaniProfiler',
	#tag : 'Analyzer'
}

{ #category : 'initialization' }
IllAllocationSiteBin >> addImmortalObject: object [

	immortalObjects add: object
]

{ #category : 'initialization' }
IllAllocationSiteBin >> addLongLivedObject: object [

	longLivedObjects add: object
]

{ #category : 'initialization' }
IllAllocationSiteBin >> addShortLivedObject: object [

	shortLivedObjects add: object
]

{ #category : 'accessing' }
IllAllocationSiteBin >> classification [

	^ classification
]

{ #category : 'accessing' }
IllAllocationSiteBin >> classification: obj [

	classification := obj
]

{ #category : 'accessing' }
IllAllocationSiteBin >> immortalObjects [

	^ immortalObjects
]

{ #category : 'initialization' }
IllAllocationSiteBin >> initialize [

	super initialize.
	immortalObjects := OrderedCollection new.
	longLivedObjects := OrderedCollection new.
	shortLivedObjects := OrderedCollection new
]

{ #category : 'accessing' }
IllAllocationSiteBin >> longLivedObjects [

	^ longLivedObjects
]

{ #category : 'accessing' }
IllAllocationSiteBin >> shortLivedObjects [

	^ shortLivedObjects
]
