Extension { #name : #RSAbstractTick }

{ #category : #'*IllimaniAllocationProfiler' }
RSAbstractTick >> ticksData [

	| rangeForDividing scaleToUse |
	scaleToUse := self isHorizontalTick ifTrue: [ xScale ]
		              ifFalse: [ yScale ].
	rangeForDividing := scaleToUse range first to: scaleToUse range last
		                    count: self configuration numberOfTicks.
	^ rangeForDividing collect: [ :e | scaleToUse invert: e ]
]
