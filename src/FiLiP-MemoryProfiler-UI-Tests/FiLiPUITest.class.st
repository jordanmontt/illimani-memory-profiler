Class {
	#name : 'FiLiPUITest',
	#superclass : 'TestCase',
	#instVars : [
		'profiler'
	],
	#category : 'FiLiP-MemoryProfiler-UI-Tests',
	#package : 'FiLiP-MemoryProfiler-UI-Tests'
}

{ #category : 'running' }
FiLiPUITest >> setUp [

	super setUp.
	profiler := FiLiP new
]

{ #category : 'running' }
FiLiPUITest >> tearDown [

	profiler forceUninstall.
	profiler := nil.
	super tearDown
]

{ #category : 'tests' }
FiLiPUITest >> testOpen [

	self timeLimit: 1 minute.

	profiler profileOn: [ 50 timesRepeat: [ Object new ] ].
	profiler open window close
]
