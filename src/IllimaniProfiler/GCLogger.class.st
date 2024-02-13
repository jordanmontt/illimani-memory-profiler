Class {
	#name : 'GCLogger',
	#superclass : 'Object',
	#instVars : [
		'fullGCs',
		'process',
		'waitingTime',
		'scavenges'
	],
	#category : 'IllimaniProfiler-Model-Statistics',
	#package : 'IllimaniProfiler',
	#tag : 'Model-Statistics'
}

{ #category : 'exporting' }
GCLogger >> export: writeStream data: someData header: aHeaderInCollection [

	| writer |
	writer := (NeoCSVWriter on: writeStream)
		writeHeader: #( #fullGCsBySecond );
		fieldWriter: #raw;
		yourself.
	
	someData do: [ :e | writer nextPut: { e } ].
	writer close
]

{ #category : 'exporting' }
GCLogger >> exportData: baseFileName [

	| writeStream |
	
	writeStream := (baseFileName , '-full-gcs' , '.csv') asFileReference createFile writeStream.
	self exportFullGCs: writeStream.
	writeStream := (baseFileName , '-scavenges' , '.csv') asFileReference createFile writeStream.
	self exportScavengesGCs: writeStream.
]

{ #category : 'exporting' }
GCLogger >> exportFullGCs: writeStream [

	self export: writeStream data: fullGCs header: #( #fullGCsBySecond )
]

{ #category : 'exporting' }
GCLogger >> exportScavengesGCs: writeStream [

	self export: writeStream data: scavenges header: #( #scavengesBySecond )
]

{ #category : 'initialization' }
GCLogger >> initialize [

	super initialize.
	fullGCs := OrderedCollection new: 10000.
	scavenges := OrderedCollection new: 10000.
	waitingTime := 1 second
]

{ #category : 'api' }
GCLogger >> registerStats [

	fullGCs add: Smalltalk vm fullGCCount.
	scavenges add: Smalltalk vm incrementalGCCount
]

{ #category : 'api' }
GCLogger >> run [

	process := [
		[ true ] whileTrue: [
			self registerStats.
			waitingTime wait ] ] fork
]

{ #category : 'api' }
GCLogger >> run: aCodeBlock [

	process := [
		[ true ] whileTrue: [
			self registerStats.
			waitingTime wait ] ] fork.
	
	aCodeBlock ensure: [ process terminate ]
]

{ #category : 'api' }
GCLogger >> terminate [

	process terminate
]

{ #category : 'accessing' }
GCLogger >> waitingTime: aDuration [

	waitingTime := aDuration
]
