Class {
	#name : 'IllFinalizationInstanceKeeper',
	#superclass : 'IllFinalizationProfiler',
	#instVars : [
		'keptInstances',
		'classesToIncreaseLifetime'
	],
	#category : 'IllimaniProfiler-Finalization-Profiler',
	#package : 'IllimaniProfiler',
	#tag : 'Finalization-Profiler'
}

{ #category : 'accessing' }
IllFinalizationInstanceKeeper >> classesToKeepReferenced: aCollection [

	"This is a hook that help to increse the lifetime of certain objects. If the allocated object belongs to one of this classes, the profiler will keep that object referenced until the end of the execution"
	classesToIncreaseLifetime := aCollection
]

{ #category : 'initialization' }
IllFinalizationInstanceKeeper >> initialize [

	super initialize.
	keptInstances := OrderedCollection new: 100000000.
	classesToIncreaseLifetime := {  }
]

{ #category : 'profiling' }
IllFinalizationInstanceKeeper >> internalRegisterAllocation: anObject [
	
	(classesToIncreaseLifetime includes: anObject class) ifTrue: [ keptInstances add: anObject ].
	
	super internalRegisterAllocation: anObject
]

{ #category : 'profiling' }
IllFinalizationInstanceKeeper >> stopProfiling [

	"Stop refencing the instances"
	keptInstances := OrderedCollection new.
	super stopProfiling
]
