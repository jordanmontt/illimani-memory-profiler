"
I am a presenter class that shows basic statistics about the object allocations.
"
Class {
	#name : 'AllocationSiteSummaryPresenter',
	#superclass : 'BasicAllocationSummaryPresenter',
	#category : 'IllimaniAllocationProfiler-UI-Widgets',
	#package : 'IllimaniAllocationProfiler-UI',
	#tag : 'Widgets'
}

{ #category : 'layout' }
AllocationSiteSummaryPresenter >> generalStatsAssociations [

	^ super generalStatsAssociations , {
		  ('Classes that allocate objects' -> self numberOfClasses).
		  ('Methods that allocate objects' -> self numberOfMethods) }
]

{ #category : 'accessing' }
AllocationSiteSummaryPresenter >> numberOfClasses [

	^ profiler stats numberOfClasses asString
]

{ #category : 'accessing' }
AllocationSiteSummaryPresenter >> numberOfMethods [

	^ profiler stats numberOfMethods asString
]
