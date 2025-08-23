Class {
	#name : 'FiLiP',
	#superclass : 'IllAbstractProfiler',
	#instVars : [
		'ephemeronsCollection',
		'statsModel'
	],
	#category : 'FiLiP-MemoryProfiler-Profiler',
	#package : 'FiLiP-MemoryProfiler',
	#tag : 'Profiler'
}

{ #category : 'exporting' }
FiLiP >> exportMetaData [
	"This exports ONLY the medata data, not the raw allocations"

	(self exporterClass on: self) exportMetaData
]

{ #category : 'exporting' }
FiLiP >> exporterClass [

	^ FiLiPExporter
]

{ #category : 'profiling' }
FiLiP >> forceFinalizationOfObjects [

	ephemeronsCollection do: [ :e | e mourn ]
]

{ #category : 'initialization' }
FiLiP >> initialize [

	super initialize.
	ephemeronsCollection := OrderedCollection new: 100000000
]

{ #category : 'profiling' }
FiLiP >> internalRegisterAllocation: newlyAllocatedObject [

	| metaClass filteredContext illEphemeron allocationSenderChain i n |
	metaClass := newlyAllocatedObject class class.
	illEphemeron := FiLiPEphemeron newTenured.
	i := 1.
	n := 120.
	allocationSenderChain := Array new: n.

	filteredContext := thisContext "proxy method"
		sender "this is me, this profiler"
		sender "this is the AbstractProfiler"
		sender "this is the IllHandler"
		"sender". "this is the instrumented method (allocator method e.g. #basicNew)"

	"Get the textual location of new."
	[ filteredContext receiver class = metaClass ] whileTrue: [
		allocationSenderChain
			at: i put: filteredContext compiledCode;
			at: i + 1 put: filteredContext pc - 1.
		i := i + 2.
		filteredContext := filteredContext sender ].

	"Now the filtered context is at the textual location of new."
	illEphemeron
		key: newlyAllocatedObject value: nil;
		textualAllocatorMethod: filteredContext compiledCode;
		offset: filteredContext pc -1.

	"Get the rest of the stack until a limit n"
	[ filteredContext isNil or: [ i > n ] ] whileFalse: [
		allocationSenderChain
			at: i put: filteredContext compiledCode;
		 	at: i + 1 put: filteredContext pc - 1.
		i := i + 2.
		filteredContext := filteredContext sender ].

	illEphemeron sendersCallStack: allocationSenderChain.
	ephemeronsCollection add: illEphemeron.
]

{ #category : 'accessing' }
FiLiP >> objectAllocations [

	^ ephemeronsCollection
]

{ #category : 'accessing - statistics' }
FiLiP >> queryAllocationStats [

	self isProfilingFinished
		ifFalse: [ ^ Warning signal: 'Need to wait until the profiling is finished to access the stats' ].

	^ statsModel ifNil: [
		  statsModel := FiLiPStatisticsQueryModel onProfiler: self ]
]

{ #category : 'profiling' }
FiLiP >> registerAllocationUsingNewSamplingRate: anObject [

	"NEDDED: Change the sampling rate in the initialize to self samplingRate: 2552.
	Why that number? It was the result of a linear regression model:
	
	prof startProfiling.
	before := Smalltalk vm parameterAt: 34.	
	Object new.
	after :=Smalltalk vm parameterAt: 34.
	prof stopProfiling.
	after - before ""2040"" " 

	| nextSamplingThreshold |
	"Fast path for sampling 100% capture all"
	samplingRate = 0 ifTrue: [
		self internalRegisterAllocation: anObject.
		^ self ].

	nextSamplingThreshold := (Smalltalk vm parameterAt: 34) - startTime // samplingRate.

	nextSamplingThreshold > samplingCounter ifTrue: [
		self internalRegisterAllocation: anObject ].

	samplingCounter := nextSamplingThreshold
]

{ #category : 'profiling' }
FiLiP >> stopProfiling [

	super stopProfiling.
	self forceFinalizationOfObjects
]
