Extension { #name : 'AllocationSiteInfoModel' }

{ #category : '*IllimaniAllocationProfiler-UI' }
AllocationSiteInfoModel >> inspectableAssociations [

	^ super inspectableAssociations , {
		  ('Allocator Class' -> allocatorClass).
		  ('Allocator Method' -> allocatorMethod).
		  ('Context' -> context).
		  ('Allocated Object' -> allocatedObject).
		  ('Allocated Object Hash' -> allocatedObjectHash) }
]

{ #category : '*IllimaniAllocationProfiler-UI' }
AllocationSiteInfoModel >> inspectorExtensionContextFingerprint: aBuilder [

	<inspectorPresentationOrder: 2 title: 'Context Fingerprint'>
	^ contextFingerprint inspectionFullString
]
