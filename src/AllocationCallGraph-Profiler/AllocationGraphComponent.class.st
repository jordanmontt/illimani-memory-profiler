Class {
	#name : 'AllocationGraphComponent',
	#superclass : 'Object',
	#instVars : [
		'isAllocationSite',
		'isLeaf',
		'isTextualAllocationSite',
		'isLongLived'
	],
	#category : 'AllocationCallGraph-Profiler-AllocationCallGraph',
	#package : 'AllocationCallGraph-Profiler',
	#tag : 'AllocationCallGraph'
}

{ #category : 'api' }
AllocationGraphComponent >> beAllocationSite [

	isAllocationSite := true
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

	isLongLived := false
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
	isLongLived := false
]

{ #category : 'testing' }
AllocationGraphComponent >> isAllocationSite [

	^ isAllocationSite
]

{ #category : 'accessing' }
AllocationGraphComponent >> isLongLived [ 

	^ isLongLived
]

{ #category : 'testing' }
AllocationGraphComponent >> isTextualAllocationSite [

	^ isTextualAllocationSite
]
