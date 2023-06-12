Class {
	#name : #IllimaniFinalizationHandler,
	#superclass : #IllimaniProfilerMpHandler,
	#instVars : [
		'profiler'
	],
	#category : #'IllimaniAllocationProfiler-Finalization Profiler'
}

{ #category : #initialization }
IllimaniFinalizationHandler >> defaultClassesToAvoidInTheContextSearch [

	^ super defaultClassesToAvoidInTheContextSearch, { self class }
]

{ #category : #evaluating }
IllimaniFinalizationHandler >> handleObjectAllocation: newlyAllocatedObject [

	| objectFinalizationModel filteredContext |
	filteredContext := self filterContext: thisContext ignoringClass: newlyAllocatedObject class.
	
	objectFinalizationModel := AllocationSiteInfoModel new
		allocatedObjectClass: newlyAllocatedObject class;
		allocatorClass: filteredContext receiver class;
		allocatorMethod: filteredContext compiledCode method;
		initializationTimestamp: Time microsecondClockValue;
		totalSizeInBytes: newlyAllocatedObject sizeInMemory;
		yourself.
	
	objectAllocations add: objectFinalizationModel.

	"Finalization"
	profiler addFinalizationFor: newlyAllocatedObject finalizer: objectFinalizationModel
]

{ #category : #accessing }
IllimaniFinalizationHandler >> profiler: anIllimaniFinalizationProfiler [

	profiler := anIllimaniFinalizationProfiler
]
