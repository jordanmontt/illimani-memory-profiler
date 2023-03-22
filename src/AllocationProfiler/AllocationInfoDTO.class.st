"
I am a class that holds the information that was was captured by the method proxies. Like the class of the allocated object, who allocated that object, the timestamp, etc.
"
Class {
	#name : #AllocationInfoDTO,
	#superclass : #Object,
	#instVars : [
		'context',
		'timestamp',
		'allocatedObjectHash',
		'allocatorClass',
		'allocatedObjectClass',
		'totalSizeInBytes',
		'allocatorMethod',
		'contextFingerprint'
	],
	#category : #'AllocationProfiler-Data-Structures'
}

{ #category : #accessing }
AllocationInfoDTO >> allocatedObjectClass [

	^ allocatedObjectClass
]

{ #category : #accessing }
AllocationInfoDTO >> allocatedObjectClass: anObject [

	allocatedObjectClass := anObject
]

{ #category : #accessing }
AllocationInfoDTO >> allocatedObjectHash [

	^ allocatedObjectHash
]

{ #category : #accessing }
AllocationInfoDTO >> allocatedObjectHash: anObject [

	allocatedObjectHash := anObject
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
AllocationInfoDTO >> contextFingerprintAsString [

	^ String streamContents: [ :stream |
		  contextFingerprint pairsDo: [ :a :b |
			  stream << b className << '>>#' << a asString << ' <- ' ] ]
]

{ #category : #accessing }
AllocationInfoDTO >> fullMethodName [

	^ allocatorMethod name
]

{ #category : #printing }
AllocationInfoDTO >> printOn: aStream [

	aStream << allocatorMethod name << ' allocated a ' << allocatedObjectClass asString
	<< ' that weights '.
	totalSizeInBytes ifNil: [ aStream << ' - ' ]
		ifNotNil: [ aStream << totalSizeInBytes humanReadableByteSizeString ]
]

{ #category : #initialization }
AllocationInfoDTO >> setContextFingerprintList: aContext [

	| iterator |
	contextFingerprint := OrderedCollection new.
	iterator := aContext.
	1 to: 10 do: [ :index |
		contextFingerprint add: iterator compiledCode method selector.
		contextFingerprint add: iterator receiver.
		iterator := iterator sender.
		iterator ifNil: [ ^ self ] ]
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
