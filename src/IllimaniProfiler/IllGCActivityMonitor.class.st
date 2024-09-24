"
I am a garbage collector monitor that register the garbage collector activity. To see how often I register the GC activity, see the method `defaultWaitingTime`.
"
Class {
	#name : 'IllGCActivityMonitor',
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
IllGCActivityMonitor >> defaultWaitingTime [

	^ 1 second
]

{ #category : 'exporting' }
IllGCActivityMonitor >> exportData: baseFileName [

	(GCActivityMonitorExporter on: self) exportData: baseFileName
]

{ #category : 'accessing' }
IllGCActivityMonitor >> fullGCs [

	^ fullGCs
]

{ #category : 'initialization' }
IllGCActivityMonitor >> initialize [

	super initialize.
	fullGCs := OrderedCollection new: 10000.
	scavenges := OrderedCollection new: 10000.
	waitingTime := self defaultWaitingTime
]

{ #category : 'api' }
IllGCActivityMonitor >> registerStats [

	fullGCs add: Smalltalk vm fullGCCount.
	scavenges add: Smalltalk vm incrementalGCCount
]

{ #category : 'api' }
IllGCActivityMonitor >> run [

	process := [
		[ true ] whileTrue: [
			self registerStats.
			waitingTime wait ] ] fork
]

{ #category : 'api' }
IllGCActivityMonitor >> run: aCodeBlock [

	process := [
		[ true ] whileTrue: [
			self registerStats.
			waitingTime wait ] ] fork.

	aCodeBlock ensure: [ self terminate ]
]

{ #category : 'accessing' }
IllGCActivityMonitor >> scavenges [

	^ scavenges
]

{ #category : 'api' }
IllGCActivityMonitor >> terminate [

	process terminate
]

{ #category : 'accessing' }
IllGCActivityMonitor >> waitingTime: aDuration [

	waitingTime := aDuration
]
