Extension { #name : 'IllAbstractProfiler' }

{ #category : '*Illimani-FrameworkProfiler-UI' }
IllAbstractProfiler >> open [

	^ (self uiClass profiler: self announcer: illimaniAnnouncer)
		  open;
		  yourself
]

{ #category : '*Illimani-FrameworkProfiler-UI' }
IllAbstractProfiler >> uiClass [

	^ self subclassResponsibility
]
