Class {
	#name : #IllimaniFinalizationHandler,
	#superclass : #MpHandler,
	#instVars : [
		'objectAllocations',
		'profiler',
		'graphWalker'
	],
	#category : #'IllimaniAllocationProfiler-Finalization Profiler'
}

{ #category : #evaluating }
IllimaniFinalizationHandler >> afterExecutionWithReceiver: receiver arguments: arguments returnValue: newlyAllocatedObject [

	| objectFinalizationModel |
	objectFinalizationModel := BasicAllocationInfoModel new
		"allocatedObjectClass: newlyAllocatedObject class;"
		initializationTimestamp: Time microsecondClockValue;
		"(graphWalker rootObject: newlyAllocatedObject) totalSizeInBytes;"
		"not necessary to walk the whole object as we are only observing the allocation size."
		totalSizeInBytes: newlyAllocatedObject sizeInMemory;
		yourself.
	objectAllocations add: objectFinalizationModel.

	"Finalization"
	profiler addFinalizationFor: newlyAllocatedObject finalizer: objectFinalizationModel.

	^ newlyAllocatedObject
]

{ #category : #initialization }
IllimaniFinalizationHandler >> clean [

	objectAllocations removeAll
]

{ #category : #initialization }
IllimaniFinalizationHandler >> initialize [

	super initialize.
	objectAllocations := OrderedCollection new.
	graphWalker := GraphSpaceStatistics new
]

{ #category : #accessing }
IllimaniFinalizationHandler >> objectAllocations [

	^ objectAllocations
]

{ #category : #accessing }
IllimaniFinalizationHandler >> profiler: anIllimaniFinalizationProfiler [

	profiler := anIllimaniFinalizationProfiler
]
