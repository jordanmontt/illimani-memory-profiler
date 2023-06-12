Class {
	#name : #IllimaniFinalizationHandler,
	#superclass : #IllimaniProfilerMpHandler,
	#instVars : [
		'profiler',
		'counter'
	],
	#category : #'IllimaniAllocationProfiler-Finalization Profiler'
}

{ #category : #evaluating }
IllimaniFinalizationHandler >> afterExecutionWithReceiver: receiver arguments: arguments returnValue: newlyAllocatedObject [

	"Finalization"
	"counter := counter + 1.
	counter % 2 = 0 ifFalse: [ ^ newlyAllocatedObject ]."

	self putEphemeron: newlyAllocatedObject.
	^ newlyAllocatedObject
]

{ #category : #initialization }
IllimaniFinalizationHandler >> clean [

	objectAllocations removeAll.
	counter := 0
]

{ #category : #initialization }
IllimaniFinalizationHandler >> defaultClassesToAvoidInTheContextSearch [

	^ super defaultClassesToAvoidInTheContextSearch, { self class }
]

{ #category : #initialization }
IllimaniFinalizationHandler >> initialize [

	super initialize.
	objectAllocations := OrderedCollection new.
	graphWalker := GraphSpaceStatistics new.
	counter := 0
]

{ #category : #accessing }
IllimaniFinalizationHandler >> objectAllocations [

	^ objectAllocations
]

{ #category : #accessing }
IllimaniFinalizationHandler >> profiler: anIllimaniFinalizationProfiler [

	profiler := anIllimaniFinalizationProfiler
]

{ #category : #evaluating }
IllimaniFinalizationHandler >> putEphemeron: newlyAllocatedObject [

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
