Class {
	#name : #AllocationInfoDTO,
	#superclass : #Object,
	#instVars : [
		'context',
		'timestamp',
		'allocatorClass',
		'allocatedObjectClass',
		'totalSizeInBytes',
		'allocatorMethod',
		'contextFingerprint',
		'allocatedObject',
		'allocatedObjectIdentityHash'
	],
	#category : #'AllocationProfiler-Data-Structures'
}

{ #category : #accessing }
AllocationInfoDTO >> allocatedObject [

	^ allocatedObject
]

{ #category : #accessing }
AllocationInfoDTO >> allocatedObject: anObj [

	allocatedObject := anObj
]

{ #category : #accessing }
AllocationInfoDTO >> allocatedObjectClass [

	^ allocatedObjectClass
]

{ #category : #accessing }
AllocationInfoDTO >> allocatedObjectClass: anObject [

	allocatedObjectClass := anObject
]

{ #category : #accessing }
AllocationInfoDTO >> allocatedObjectIdentityHash [

	^ allocatedObjectIdentityHash
]

{ #category : #accessing }
AllocationInfoDTO >> allocatedObjectIdentityHash: anObject [

	allocatedObjectIdentityHash := anObject
]

{ #category : #accessing }
AllocationInfoDTO >> allocatorClass [

	^ allocatorClass
]

{ #category : #accessing }
AllocationInfoDTO >> allocatorClass: anObject [

	allocatorClass := anObject
]

{ #category : #accessing }
AllocationInfoDTO >> allocatorMethod: aCompiledMethod [

	allocatorMethod := aCompiledMethod
]

{ #category : #accessing }
AllocationInfoDTO >> context [

	^ context
]

{ #category : #accessing }
AllocationInfoDTO >> context: anObject [

	context := anObject
]

{ #category : #accessing }
AllocationInfoDTO >> contextFingerprint [

	^ contextFingerprint
]

{ #category : #accessing }
AllocationInfoDTO >> contextFingerprint: aContext [

	contextFingerprint := self getContextFingerprintStream: aContext
]

{ #category : #accessing }
AllocationInfoDTO >> fullMethodName [

	^ allocatorMethod name
]

{ #category : #initialization }
AllocationInfoDTO >> getContextFingerprintStream: aContext [

	^ String streamContents: [ :stream |
		| iterator |
		iterator := aContext.
		1 to: 10 do: [ :index |
			iterator printOn: stream.
			stream << String cr.
			iterator := iterator sender.
			iterator ifNil: [ ^ stream ] ] ]
]

{ #category : #printing }
AllocationInfoDTO >> printOn: aStream [

	aStream << allocatorMethod name << ' allocated a ' << allocatedObjectClass asString
	<< ' that weights '.
	totalSizeInBytes ifNil: [ aStream << ' - ' ]
		ifNotNil: [ aStream << totalSizeInBytes humanReadableByteSizeString ]
]

{ #category : #accessing }
AllocationInfoDTO >> timestamp [

	^ timestamp
]

{ #category : #accessing }
AllocationInfoDTO >> timestamp: anObject [

	timestamp := anObject
]

{ #category : #accessing }
AllocationInfoDTO >> totalSizeInBytes [
	"Returns the total size in memory in bytes"

	^ totalSizeInBytes
]

{ #category : #accessing }
AllocationInfoDTO >> totalSizeInBytes: aNumber [

	totalSizeInBytes := aNumber
]
