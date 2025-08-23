Class {
	#name : 'IllMockProfiler',
	#superclass : 'Object',
	#instVars : [
		'allocations'
	],
	#category : 'Illimani-FrameworkProfiler-Tests-Utilities',
	#package : 'Illimani-FrameworkProfiler-Tests',
	#tag : 'Utilities'
}

{ #category : 'accessing' }
IllMockProfiler >> objectAllocations [

	^ allocations
]

{ #category : 'accessing' }
IllMockProfiler >> objectAllocations: aCollection [

	allocations := aCollection
]

{ #category : 'accessing' }
IllMockProfiler >> profiledCode [

	^ 'TestProfiler testTheProfiler'
]

{ #category : 'accessing' }
IllMockProfiler >> samplingRate [

	^ 100
]

{ #category : 'accessing' }
IllMockProfiler >> totalFullGCs [

	^ 2
]

{ #category : 'accessing' }
IllMockProfiler >> totalScavenges [

	^ 156
]

{ #category : 'accessing' }
IllMockProfiler >> totalTime [

	^ 2000000 "2 microseconds"
]
