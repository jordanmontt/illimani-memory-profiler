Class {
	#name : 'TextualLocationOfNewStrategy',
	#superclass : 'AllocationSiteIdentificationStrategy',
	#category : 'IllimaniProfiler-Analyzer',
	#package : 'IllimaniProfiler',
	#tag : 'Analyzer'
}

{ #category : 'as yet unclassified' }
TextualLocationOfNewStrategy >> identifyAllocationSites: objectAllocations [
	"do nothing as ephemerons have already the textual location as the allocation site"
]

{ #category : 'as yet unclassified' }
TextualLocationOfNewStrategy >> stopCriterionForAllocatedClass: allocatedObjectClass receiverClass: receiverClass [

	^ (allocatedObjectClass = receiverClass or: [ allocatedObjectClass inheritsFrom: receiverClass ]) not
]
