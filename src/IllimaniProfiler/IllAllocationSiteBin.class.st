"
I am a simple data structure used by the class IllAnalyzer.
"
Class {
	#name : 'IllAllocationSiteBin',
	#superclass : 'Object',
	#instVars : [
		'immortalObjects',
		'longLivedObjects',
		'shortLivedObjects',
		'classification',
		'allocationSite'
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
IllAllocationSiteBin >> allocationSite: anIllAllocationSite [ 
	allocationSite := anIllAllocationSite
]

{ #category : 'accessing' }
IllAllocationSiteBin >> allocationSiteForMethod: aMethod byte: aByteNumber [

	allocationSite := IllAllocationSite method: aMethod byte: aByteNumber
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

{ #category : 'accessing' }
IllAllocationSiteBin >> totalAllocations [

	^ immortalObjects size + longLivedObjects size + shortLivedObjects size
]
