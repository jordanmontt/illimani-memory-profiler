Class {
	#name : #IllimaniFinalizationHandler,
	#superclass : #MpHandler,
	#instVars : [
		'objectAllocations',
		'profiler',
		'graphWalker',
		'counter'
	],
	#category : #'IllimaniAllocationProfiler-Finalization Profiler'
}

{ #category : #evaluating }
IllimaniFinalizationHandler >> afterExecutionWithReceiver: receiver arguments: arguments returnValue: newlyAllocatedObject [

	"Finalization"
	"counter := counter + 1.
	counter % 100 = 0 ifFalse: [ ^ newlyAllocatedObject ]."

	self putEphemeron: newlyAllocatedObject.
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

	| objectFinalizationModel |
	objectFinalizationModel := BasicAllocationInfoModel new
		allocatedObjectClass: newlyAllocatedObject class;
		initializationTimestamp: Time microsecondClockValue;
		totalSizeInBytes: newlyAllocatedObject sizeInMemory;
		yourself.
	objectAllocations add: objectFinalizationModel.

	"Finalization"
	profiler addFinalizationFor: newlyAllocatedObject finalizer: objectFinalizationModel
]
