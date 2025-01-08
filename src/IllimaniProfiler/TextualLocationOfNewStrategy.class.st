Class {
	#name : 'TextualLocationOfNewStrategy',
	#superclass : 'Object',
	#category : 'IllimaniProfiler-Analyzer',
	#package : 'IllimaniProfiler',
	#tag : 'Analyzer'
}

{ #category : 'as yet unclassified' }
TextualLocationOfNewStrategy >> identifyAllocationSites: objectAllocations [

	objectAllocations do: [ :illEphemeron |
		| callStack i |
		callStack := illEphemeron sendersCallStack.
		i := 1.
		[ i <= callStack size ] whileTrue: [
			| sender |
			sender := callStack at: i.
			(illEphemeron allocatedObjectClass isKindOf: sender method methodClass) ifFalse: [
				"Set the allocation site"
				illEphemeron
					allocatorMethod: sender method;
					offset: sender offset.
				i := callStack size ].
			i := i + 1 ] ].
	^ objectAllocations
]
