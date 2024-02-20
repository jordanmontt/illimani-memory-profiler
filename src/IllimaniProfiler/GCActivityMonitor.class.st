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
	waitingTime := 1 second
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
