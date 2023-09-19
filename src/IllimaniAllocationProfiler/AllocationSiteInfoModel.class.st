Class {
	#name : 'AllocationSiteInfoModel',
	#superclass : 'BasicAllocationInfoModel',
	#instVars : [
		'context',
		'allocatorClass',
		'allocatorMethod',
		'contextFingerprint'
	],
	#category : 'IllimaniAllocationProfiler-Model',
	#package : 'IllimaniAllocationProfiler',
	#tag : 'Model'
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

	contextFingerprint := self getContextFingerprintStream: aContext
]

{ #category : 'accessing' }
AllocationSiteInfoModel >> fullMethodName [

	^ allocatorMethod name
]

{ #category : 'initialization' }
AllocationSiteInfoModel >> getContextFingerprintStream: aContext [

	self flag: 'This is the first "naive" implementation of the context fingerprint'.

	^ String streamContents: [ :stream |
		| iterator |
		iterator := aContext.
		1 to: 10 do: [ :index |
			iterator printOn: stream.
			stream << String cr.
			iterator := iterator sender.
			iterator ifNil: [ ^ stream ] ] ]
]

{ #category : 'printing' }
AllocationSiteInfoModel >> printOn: aStream [

	aStream << allocatorMethod name << ' allocated a ' << allocatedObjectClass asString
	<< ' that weights '.
	totalSizeInBytes ifNil: [ aStream << ' - ' ]
		ifNotNil: [ aStream << totalSizeInBytes humanReadableByteSizeString ]
]
