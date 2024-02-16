Class {
	#name : 'GCActivityMonitorExporter',
	#superclass : 'Object',
	#instVars : [
		'gcActivityMonitor'
	],
	#category : 'IllimaniProfiler-File-Exporters',
	#package : 'IllimaniProfiler',
	#tag : 'File-Exporters'
}

{ #category : 'instance creation' }
GCActivityMonitorExporter class >> on: aGCActivityMonitor [ 

	^ self new
		gcActivityMonitor: aGCActivityMonitor;
		yourself
]

{ #category : 'exporting' }
GCActivityMonitorExporter >> export: writeStream data: someData header: aHeaderInCollection [

	| writer |
	writer := (NeoCSVWriter on: writeStream)
		writeHeader: #( #fullGCsBySecond );
		fieldWriter: #raw;
		yourself.
	
	someData do: [ :e | writer nextPut: { e } ].
	writer close
]

{ #category : 'accessing' }
GCActivityMonitorExporter >> exportData: baseFileName [

	| writeStream |
	
	writeStream := (baseFileName , '-full-gcs' , '.csv') asFileReference createFile writeStream.
	self exportFullGCs: writeStream.
	writeStream := (baseFileName , '-scavenges' , '.csv') asFileReference createFile writeStream.
	self exportScavengesGCs: writeStream.
]

{ #category : 'exporting' }
GCActivityMonitorExporter >> exportFullGCs: writeStream [

	self export: writeStream data: gcActivityMonitor fullGCs header: #( #fullGCsBySecond )
]

{ #category : 'exporting' }
GCActivityMonitorExporter >> exportScavengesGCs: writeStream [

	self export: writeStream data: gcActivityMonitor scavenges header: #( #scavengesBySecond )
]

{ #category : 'exporting' }
GCActivityMonitorExporter >> gcActivityMonitor: anObject [

	gcActivityMonitor := anObject
]
