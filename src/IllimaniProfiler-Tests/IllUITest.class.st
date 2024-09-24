Class {
	#name : 'IllUITest',
	#superclass : 'TestCase',
	#instVars : [
		'profiler'
	],
	#category : 'IllimaniProfiler-Tests',
	#package : 'IllimaniProfiler-Tests'
}

{ #category : 'running' }
IllUITest >> setUp [

	super setUp.
	profiler := IllMemoryProfiler new
]

{ #category : 'running' }
IllUITest >> tearDown [

	profiler forceUninstall.
	profiler := nil.
	super tearDown
]

{ #category : 'tests' }
IllUITest >> testOpen [

	self timeLimit: 1 minute.

	profiler profileOn: [ 50 timesRepeat: [ Object new ] ].
	profiler open window close
]
