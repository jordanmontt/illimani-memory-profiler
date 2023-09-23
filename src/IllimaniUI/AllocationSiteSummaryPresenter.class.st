"
I am a presenter class that shows basic statistics about the object allocations.
"
Class {
	#name : 'AllocationSiteSummaryPresenter',
	#superclass : 'AllocationSummaryPresenter',
	#category : 'IllimaniUI-Widgets',
	#package : 'IllimaniUI',
	#tag : 'Widgets'
}

{ #category : 'layout' }
AllocationSiteSummaryPresenter >> generalStatsAssociations [

	^ super generalStatsAssociations , {
		  ('Classes that allocate objects' -> profiler stats numberOfClasses asString).
		  ('Methods that allocate objects' -> profiler stats numberOfMethods asString) }
]
