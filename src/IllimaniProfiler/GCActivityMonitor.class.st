"
I am a garbage collector monitor that register the garbage collector activity. To see how often I register the GC activity, see the method `defaultWaitingTime`.
"
Class {
	#name : 'GCActivityMonitor',
	#superclass : 'Object',
	#instVars : [
		'fullGCs',
		'process',
		'waitingTime',
		'scavenges'
	],
	#category : 'IllimaniProfiler-GC-Monitor',
	#package : 'IllimaniProfiler',
	#tag : 'GC-Monitor'
}

{ #category : 'initialization' }
GCActivityMonitor >> defaultWaitingTime [

	^ 1 second
]

{ #category : 'exporting' }
GCActivityMonitor >> exportData: baseFileName [

	(GCActivityMonitorExporter on: self) exportData: baseFileName
]

{ #category : 'accessing' }
GCActivityMonitor >> fullGCs [

	^ fullGCs
]

{ #category : 'initialization' }
GCActivityMonitor >> initialize [

	super initialize.
	fullGCs := OrderedCollection new: 10000.
	scavenges := OrderedCollection new: 10000.
	waitingTime := self defaultWaitingTime
]

{ #category : 'api' }
GCActivityMonitor >> registerStats [

	fullGCs add: Smalltalk vm fullGCCount.
	scavenges add: Smalltalk vm incrementalGCCount
]

{ #category : 'api' }
GCActivityMonitor >> run [

	process := [
		[ true ] whileTrue: [
			self registerStats.
			waitingTime wait ] ] fork
]

{ #category : 'api' }
GCActivityMonitor >> run: aCodeBlock [

	process := [
		[ true ] whileTrue: [
			self registerStats.
			waitingTime wait ] ] fork.

	aCodeBlock ensure: [ self terminate ]
]

{ #category : 'accessing' }
GCActivityMonitor >> scavenges [

	^ scavenges
]

{ #category : 'api' }
GCActivityMonitor >> terminate [

	process terminate
]

{ #category : 'accessing' }
GCActivityMonitor >> waitingTime: aDuration [

	waitingTime := aDuration
]
