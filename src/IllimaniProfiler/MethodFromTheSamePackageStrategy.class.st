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

{ #category : 'instance creation' }
MethodFromTheSamePackageStrategy class >> classesToMatch: aCol [

	^ self new
		  classesToMatch: aCol;
		  yourself
]

{ #category : 'accessing' }
MethodFromTheSamePackageStrategy >> classesToMatch [

	^ classesToMatch
]

{ #category : 'accessing' }
MethodFromTheSamePackageStrategy >> classesToMatch: aCol [

	classesToMatch := aCol
]

{ #category : 'accessing' }
MethodFromTheSamePackageStrategy >> packages: aCollectionOfPackages [

	classesToMatch := aCollectionOfPackages flatCollect: #definedClasses
]

{ #category : 'api' }
MethodFromTheSamePackageStrategy >> removeMisclassifiedSites: aDictionary [

	^ aDictionary select: [ :illAllocationSiteBin |
		  classesToMatch includes: illAllocationSiteBin allocationSite method methodClass ]
]

{ #category : 'internal' }
MethodFromTheSamePackageStrategy >> stopCriterionForAllocatedClass: allocatedObjectClass receiverClass: receiverClass [

	^ classesToMatch includes: receiverClass
]
