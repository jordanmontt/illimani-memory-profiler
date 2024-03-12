"
I am a presenter class that shows basic statistics about the object allocations.
"
Class {
	#name : 'ProfilerWithAllocationSiteSummaryPresenter',
	#superclass : 'ProfilerSummaryPresenter',
	#category : 'IllimaniUI-Widgets',
	#package : 'IllimaniUI',
	#tag : 'Widgets'
}

{ #category : 'layout' }
ProfilerWithAllocationSiteSummaryPresenter >> generalStatsAssociations [

	^ super generalStatsAssociations , {
		  ('Classes that allocate objects' -> profiler stats numberOfClasses asString).
		  ('Methods that allocate objects' -> profiler stats numberOfMethods asString) }
]
