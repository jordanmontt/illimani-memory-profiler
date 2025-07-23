Class {
	#name : 'IllPredictor',
	#superclass : 'Object',
	#instVars : [
		'allocationSite',
		'lifetimes',
		'types'
	],
	#category : 'IllimaniProfiler-Experiments',
	#package : 'IllimaniProfiler',
	#tag : 'Experiments'
}

{ #category : 'adding' }
IllPredictor >> addLifetime: anInteger [

	| normalizedNumber |
	normalizedNumber := (anInteger log: 2) > 20 "because 2 ^ 20 is 1 MB"
		                    ifTrue: [ (anInteger log: 2) floor ]
		                    ifFalse: [ 0 ].
	lifetimes add: normalizedNumber
]

{ #category : 'adding' }
IllPredictor >> addType: aClass [
	types add: aClass
]

{ #category : 'accessing' }
IllPredictor >> allocationSite: anIllAllocationSite [ 
	allocationSite := anIllAllocationSite
]

{ #category : 'initialization' }
IllPredictor >> initialize [

	super initialize.
	lifetimes := Bag new.
	types := Bag new
]
