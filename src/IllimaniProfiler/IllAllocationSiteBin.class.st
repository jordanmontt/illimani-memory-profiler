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
	#category : 'IllimaniProfiler-Inspector-Utilities',
	#package : 'IllimaniProfiler',
	#tag : 'Inspector-Utilities'
}

{ #category : 'api' }
IllAllocationSiteBin >> addImmortalObject: object [

	immortalObjects add: object
]

{ #category : 'api' }
IllAllocationSiteBin >> addLongLivedObject: object [

	longLivedObjects add: object
]

{ #category : 'api' }
IllAllocationSiteBin >> addShortLivedObject: object [

	shortLivedObjects add: object
]

{ #category : 'accessing' }
IllAllocationSiteBin >> allObjects [

	^ self longLivedObjects , self immortalObjects , self shortLivedObjects
]

{ #category : 'accessing' }
IllAllocationSiteBin >> allocationSite [

	^ allocationSite
]

{ #category : 'accessing' }
IllAllocationSiteBin >> allocationSite: anIllAllocationSite [ 
	allocationSite := anIllAllocationSite
]

{ #category : 'accessing' }
IllAllocationSiteBin >> classification [

	^ classification
]

{ #category : 'accessing' }
IllAllocationSiteBin >> classification: obj [

	classification := obj
]

{ #category : 'testing' }
IllAllocationSiteBin >> containsClass: anObjClass [

	| block |
	block := [ :e | e allocatedObjectClass = anObjClass ].
	^ (longLivedObjects contains: block) or: [
		  (immortalObjects contains: block) or: [
			  shortLivedObjects contains: block ] ]
]

{ #category : 'testing' }
IllAllocationSiteBin >> hasDoItAllocationSite [

	^ self allObjects anySatisfy: [ :illEphe | illEphe sendersCallStack hasDoItSelector ]
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

{ #category : 'inspector' }
IllAllocationSiteBin >> inspectorAllocSite [

	<inspectorPresentationOrder: 901 title: 'Allocation site'>
	^ allocationSite inspectorPresenter
]

{ #category : 'testing' }
IllAllocationSiteBin >> isAmbiguous [

	^ shortLivedObjects notEmpty and: [ longLivedObjects notEmpty or: [ immortalObjects notEmpty ] ]
]

{ #category : 'testing' }
IllAllocationSiteBin >> isImmortal [

	^ classification = #immortal
]

{ #category : 'testing' }
IllAllocationSiteBin >> isLong [

	^ classification = #long
]

{ #category : 'testing' }
IllAllocationSiteBin >> isLongOrImmortal [

	^ self isLong or: [ self isImmortal ]
]

{ #category : 'testing' }
IllAllocationSiteBin >> isShort [

	^ classification = #short
]

{ #category : 'accessing' }
IllAllocationSiteBin >> longLivedObjects [

	^ longLivedObjects
]

{ #category : 'printing' }
IllAllocationSiteBin >> printOn: aStream [

	aStream << classification << ' bin '
]

{ #category : 'accessing' }
IllAllocationSiteBin >> shortLivedObjects [

	^ shortLivedObjects
]

{ #category : 'accessing' }
IllAllocationSiteBin >> totalAllocations [

	^ immortalObjects size + longLivedObjects size + shortLivedObjects size
]
