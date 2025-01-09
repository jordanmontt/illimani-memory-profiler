Class {
	#name : 'MethodFromTheSamePackageStrategy',
	#superclass : 'AllocationSiteIdentificationStrategy',
	#instVars : [
		'classesToMatch'
	],
	#category : 'IllimaniProfiler-Analyzer',
	#package : 'IllimaniProfiler',
	#tag : 'Analyzer'
}

{ #category : 'accessing' }
MethodFromTheSamePackageStrategy >> classesToMatch [

	^ classesToMatch
]

{ #category : 'accessing' }
MethodFromTheSamePackageStrategy >> packages: aCollectionOfPackages [

	classesToMatch := aCollectionOfPackages flatCollect: #definedClasses
]

{ #category : 'as yet unclassified' }
MethodFromTheSamePackageStrategy >> stopCriterionForAllocatedClass: allocatedObjectClass receiverClass: receiverClass [

	^ classesToMatch includes: receiverClass
]
