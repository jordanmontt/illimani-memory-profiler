Class {
	#name : 'IllEphemeronAllocationSite',
	#superclass : 'IllEphemeron',
	#type : 'ephemeron',
	#instVars : [
		'allocatorClass',
		'allocatorMethod'
	],
	#category : 'IllimaniProfiler-Allocation-Site-Plus-Finalization',
	#package : 'IllimaniProfiler',
	#tag : 'Allocation-Site-Plus-Finalization'
}

{ #category : 'accessing' }
IllEphemeronAllocationSite >> allocatorClass [

	^ allocatorClass
]

{ #category : 'accessing' }
IllEphemeronAllocationSite >> allocatorClass: anObject [

	allocatorClass := anObject
]

{ #category : 'accessing' }
IllEphemeronAllocationSite >> allocatorMethod [

	^ allocatorMethod
]

{ #category : 'accessing' }
IllEphemeronAllocationSite >> allocatorMethod: anObject [

	allocatorMethod := anObject
]

{ #category : 'exporting' }
IllEphemeronAllocationSite >> flattenedInstanceVariables [

	^ super flattenedInstanceVariables , {
		  allocatorClass.
		  allocatorMethod }
]

{ #category : 'inspector - extensions' }
IllEphemeronAllocationSite >> inspectionElements [

	^ super inspectionElements , {
		  ('Allocator class' -> allocatorClass).
		  ('Allocator method' -> allocatorMethod) }
]
