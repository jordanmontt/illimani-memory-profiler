Extension { #name : 'AllocationSiteInfoModel' }

{ #category : '*IllimaniUI' }
AllocationSiteInfoModel >> inspectableAssociations [

	^ super inspectableAssociations , {
		  ('Allocator Class' -> allocatorClass).
		  ('Allocator Method' -> allocatorMethod).
		  ('Context' -> context) }
]

{ #category : '*IllimaniUI' }
AllocationSiteInfoModel >> inspectorExtensionContextFingerprint: aBuilder [

	<inspectorPresentationOrder: 2 title: 'Context Fingerprint'>
	^ contextFingerprint inspectionFullString
]
