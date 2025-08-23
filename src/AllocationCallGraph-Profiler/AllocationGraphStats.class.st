Class {
	#name : 'AllocationGraphStats',
	#superclass : 'Object',
	#instVars : [
		'allocatedSamples'
	],
	#category : 'AllocationCallGraph-Profiler-AllocationCallGraph',
	#package : 'AllocationCallGraph-Profiler',
	#tag : 'AllocationCallGraph'
}

{ #category : 'accessing' }
AllocationGraphStats >> allocatedSamples [

	^ allocatedSamples
]

{ #category : 'initialization' }
AllocationGraphStats >> initialize [

	super initialize.
	allocatedSamples := Set new
]

{ #category : 'printing' }
AllocationGraphStats >> printOn: aStream [

	aStream
		nextPutAll: 'weight ';
		print: allocatedSamples size
]

{ #category : 'api' }
AllocationGraphStats >> updateFromSample: aSample [

	allocatedSamples add: aSample
]
