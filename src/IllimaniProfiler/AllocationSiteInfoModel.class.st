Class {
	#name : 'AllocationSiteInfoModel',
	#superclass : 'AllocationFinalizationInfoModel',
	#instVars : [
		'context',
		'allocatorMethod',
		'allocatorClass',
		'contextFingerprint'
	],
	#category : 'IllimaniProfiler-Model-Allocation',
	#package : 'IllimaniProfiler',
	#tag : 'Model-Allocation'
}

{ #category : 'accessing' }
AllocationSiteInfoModel >> allocatorClass [

	^ allocatorClass
]

{ #category : 'accessing' }
AllocationSiteInfoModel >> allocatorClass: anObject [

	allocatorClass := anObject
]

{ #category : 'accessing' }
AllocationSiteInfoModel >> allocatorMethod [

	^ allocatorMethod
]

{ #category : 'accessing' }
AllocationSiteInfoModel >> allocatorMethod: aCompiledMethod [

	allocatorMethod := aCompiledMethod
]

{ #category : 'accessing' }
AllocationSiteInfoModel >> context [

	^ context
]

{ #category : 'accessing' }
AllocationSiteInfoModel >> context: anObject [

	context := anObject
]

{ #category : 'accessing' }
AllocationSiteInfoModel >> contextFingerprint [

	^ contextFingerprint
]

{ #category : 'accessing' }
AllocationSiteInfoModel >> contextFingerprint: aContext [

	contextFingerprint := self getContextFingerprint: aContext
]

{ #category : 'accessing' }
AllocationSiteInfoModel >> fullMethodName [

	^ allocatorMethod name
]

{ #category : 'initialization' }
AllocationSiteInfoModel >> getContextFingerprint: aContext [

	^ "String streamContents: [ :stream | aContext debugStack: 2 on: stream ]" aContext asString
]

{ #category : 'inspector - extensions' }
AllocationSiteInfoModel >> inspectableAssociations [

	^ super inspectableAssociations , {
		  ('Allocator Class' -> allocatorClass).
		  ('Allocator Method' -> allocatorMethod).
		  ('Context' -> context) }
]

{ #category : 'inspector - extensions' }
AllocationSiteInfoModel >> inspectorExtensionContextFingerprint: aBuilder [

	"<inspectorPresentationOrder: 2 title: 'Context Fingerprint'>"
	^ self contextFingerprint contents inspectionFullString
]

{ #category : 'printing' }
AllocationSiteInfoModel >> printOn: aStream [

	aStream << allocatorMethod name << ' allocated a ' << allocatedObjectClass asString
	<< ' that weights '.
	sizeInBytes ifNil: [ aStream << ' - ' ]
		ifNotNil: [ aStream << sizeInBytes humanReadableByteSizeString ]
]
