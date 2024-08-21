"
I am the memory profiler that *keeps* a reference to all the captured allocated objects. Normally, users should not use me. I am usefult for doing experiments.
"
Class {
	#name : 'IllMemoryProfilerInstanceKeeper',
	#superclass : 'IllMemoryProfiler',
	#instVars : [
		'keptInstances',
		'classesToIncreaseLifetime'
	],
	#category : 'IllimaniProfiler-Profiler',
	#package : 'IllimaniProfiler',
	#tag : 'Profiler'
}

{ #category : 'accessing' }
IllMemoryProfilerInstanceKeeper >> classesToKeepReferenced: aCollection [

	"This is a hook that help to increse the lifetime of certain objects. If the allocated object belongs to one of this classes, the profiler will keep that object referenced until the end of the execution"
	classesToIncreaseLifetime := aCollection
]

{ #category : 'initialization' }
IllMemoryProfilerInstanceKeeper >> initialize [

	super initialize.
	keptInstances := OrderedCollection new: 100000000
]

{ #category : 'profiling' }
IllMemoryProfilerInstanceKeeper >> internalRegisterAllocation: anObject [

	"Optimization"
	classesToIncreaseLifetime ifNil: [
		super internalRegisterAllocation: anObject.
		^ self ].
	
	(classesToIncreaseLifetime includes: anObject class) ifTrue: [
		keptInstances add: anObject ].

	super internalRegisterAllocation: anObject
]

{ #category : 'profiling' }
IllMemoryProfilerInstanceKeeper >> stopProfiling [

	"Stop refencing the instances"
	keptInstances := OrderedCollection new.
	super stopProfiling
]
