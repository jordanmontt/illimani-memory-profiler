"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestIllimaniProfiler',
	#superclass : 'PackageManifest',
	#category : 'IllimaniProfiler-Manifest',
	#package : 'IllimaniProfiler',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestIllimaniProfiler class >> ruleLongMethodsRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGClassDefinition #(#IllMemoryProfiler)) #'2025-01-08T13:18:18.836886+01:00') )
]
