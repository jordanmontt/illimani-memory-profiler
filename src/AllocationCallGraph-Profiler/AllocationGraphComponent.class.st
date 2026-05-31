Class {
	#name : 'AllocationGraphComponent',
	#superclass : 'Object',
	#instVars : [
		'isAllocationSite',
		'isLeaf',
		'isTextualAllocationSite',
		'isLongLived',
		'isShortLived',
		'isAmbiguous',
		'allocatedObjectTypes'
	],
	#category : 'AllocationCallGraph-Profiler-AllocationCallGraph',
	#package : 'AllocationCallGraph-Profiler',
	#tag : 'AllocationCallGraph'
}

{ #category : 'accessing' }
AllocationGraphComponent >> allocatedObjectTypes [

	^ allocatedObjectTypes ifNil: [
		  allocatedObjectTypes := self allocatedSamples collect: #allocatedObjectClass as: Set ]
]

{ #category : 'api' }
AllocationGraphComponent >> beAllocationSite [

	isAllocationSite := true
]

{ #category : 'api' }
AllocationGraphComponent >> beAmbiguous [

	isAmbiguous := true
]

{ #category : 'api' }
AllocationGraphComponent >> beImmortal [

	self beLongLived
]

{ #category : 'api' }
AllocationGraphComponent >> beLeaf [

	isLeaf := true
]

{ #category : 'api' }
AllocationGraphComponent >> beLongLived [

	isLongLived := true
]

{ #category : 'api' }
AllocationGraphComponent >> beShortLived [

	isShortLived := true
]

{ #category : 'api' }
AllocationGraphComponent >> beTextualAllocationSite [

	isTextualAllocationSite := true
]

{ #category : 'initialization' }
AllocationGraphComponent >> initialize [

    super initialize.
    isAllocationSite := false.
    isTextualAllocationSite := false.

    isLongLived := false.
    isShortLived := false.
    isAmbiguous := false
]

{ #category : 'testing' }
AllocationGraphComponent >> isAllocationSite [

	^ isAllocationSite
]

{ #category : 'api' }
AllocationGraphComponent >> isAllocationSite: boolean [

	isAllocationSite := boolean 
]

{ #category : 'accessing' }
AllocationGraphComponent >> isImmortal [

    ^ self isLongLived
]

{ #category : 'accessing' }
AllocationGraphComponent >> isLongLived [

    isLongLived ifNil: [ ^ false ].
    ^ isLongLived
]

{ #category : 'api' }
AllocationGraphComponent >> isShortLived [

    isShortLived ifNil: [ ^ false ].
    ^ isShortLived
]

{ #category : 'testing' }
AllocationGraphComponent >> isTextualAllocationSite [

	^ isTextualAllocationSite
]
