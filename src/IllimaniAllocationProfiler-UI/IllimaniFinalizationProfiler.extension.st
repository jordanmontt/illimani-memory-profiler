Extension { #name : #IllimaniFinalizationProfiler }

{ #category : #'*IllimaniAllocationProfiler-UI' }
IllimaniFinalizationProfiler >> palu4 [

	^ IllimaniDistributionForFinalization new
		data: self objectAllocations;
		applyGroupData;
		palu4
]
