Class {
	#name : #IllimaniFinalizationHandler,
	#superclass : #MpHandler,
	#instVars : [
		'objectAllocations',
		'profiler'
	],
	#category : #'IllimaniAllocationProfiler-Finalization'
}

{ #category : #evaluating }
IllimaniFinalizationHandler >> afterExecutionWithReceiver: receiver arguments: arguments returnValue: newlyAllocatedObject [

	| objectFinalizationModel |
	objectFinalizationModel := BasicAllocationInfoModel new
		                           allocatedObjectClass: newlyAllocatedObject class;
		                           initializationTimestamp: Time microsecondClockValue;
		                           profiler: profiler;
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
	objectAllocations := OrderedCollection new
]

{ #category : #accessing }
IllimaniFinalizationHandler >> objectAllocations [

	^ objectAllocations
]

{ #category : #accessing }
IllimaniFinalizationHandler >> profiler: anIllimaniFinalizationProfiler [

	profiler := anIllimaniFinalizationProfiler
]
