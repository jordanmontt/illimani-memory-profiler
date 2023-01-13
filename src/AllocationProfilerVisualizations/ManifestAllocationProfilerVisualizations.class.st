"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestAllocationProfilerVisualizations,
	#superclass : #PackageManifest,
	#category : #'AllocationProfilerVisualizations-Manifest'
}

{ #category : #'code-critics' }
ManifestAllocationProfilerVisualizations class >> ruleCollectionProtocolRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#SebasVisualizations #numberOfAllocatedObjectsPerSecondPerClassLineChartCanvas #false)) #'2022-09-30T10:45:39.209076+02:00') )
]
