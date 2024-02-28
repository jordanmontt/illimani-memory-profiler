Class {
	#name : 'IllMockProfiler',
	#superclass : 'Object',
	#instVars : [
		'allocations',
		'gcMonitor'
	],
	#category : 'IllimaniProfiler-Tests-Exporters',
	#package : 'IllimaniProfiler-Tests',
	#tag : 'Exporters'
}

{ #category : 'accessing' }
IllMockProfiler >> gcActivityMonitor [

	^ gcMonitor
]

{ #category : 'as yet unclassified' }
IllMockProfiler >> gcMonitor: anIllMockGCMonitor [

	gcMonitor := anIllMockGCMonitor
]

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
