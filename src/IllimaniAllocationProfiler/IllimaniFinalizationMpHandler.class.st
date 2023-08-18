Class {
	#name : #IllimaniFinalizationMpHandler,
	#superclass : #IllimaniProfilerMpHandler,
	#instVars : [
		'profiler'
	],
	#category : #'IllimaniAllocationProfiler-Finalization Profiler'
}

{ #category : #initialization }
IllimaniFinalizationMpHandler >> defaultClassesToAvoidInTheContextSearch [

	^ super defaultClassesToAvoidInTheContextSearch, { self class }
]

{ #category : #evaluating }
IllimaniFinalizationMpHandler >> handleObjectAllocation: newlyAllocatedObject [

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
IllimaniFinalizationMpHandler >> profiler: anIllimaniFinalizationProfiler [

	profiler := anIllimaniFinalizationProfiler
]
