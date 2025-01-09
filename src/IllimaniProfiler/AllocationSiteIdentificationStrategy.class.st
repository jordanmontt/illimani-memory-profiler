Class {
	#name : 'AllocationSiteIdentificationStrategy',
	#superclass : 'Object',
	#category : 'IllimaniProfiler-Analyzer',
	#package : 'IllimaniProfiler',
	#tag : 'Analyzer'
}

{ #category : 'as yet unclassified' }
AllocationSiteIdentificationStrategy >> identifyAllocationSiteFor: illEphemeron [

	| callStack i sender |
	callStack := illEphemeron sendersCallStack.
	i := 1.
	[ i <= callStack size ] whileTrue: [
		sender := callStack at: i.
		(self stopCriterionForAllocatedClass: illEphemeron allocatedObjectClass receiverClass: sender method methodClass)
			ifTrue: [	
				illEphemeron
					allocatorMethod: sender method;
					offset: sender offset.
				^ self ].
		i := i + 1 ]
]

{ #category : 'as yet unclassified' }
AllocationSiteIdentificationStrategy >> identifyAllocationSites: objectAllocations [

	objectAllocations do: [ :illEphemeron | self identifyAllocationSiteFor: illEphemeron ].
	^ objectAllocations
]

{ #category : 'as yet unclassified' }
AllocationSiteIdentificationStrategy >> stopCriterionForAllocatedClass: allocatedObjectClass receiverClass: receiverClass [

	^ self subclassResponsibility
]
