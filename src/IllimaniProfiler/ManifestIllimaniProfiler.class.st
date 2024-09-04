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
ManifestIllimaniProfiler class >> ruleCollectionProtocolRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGClassDefinition #(#IllAnalyzer)) #'2024-08-28T17:12:03.446124+02:00') )
]

{ #category : 'code-critics' }
ManifestIllimaniProfiler class >> ruleReGuardClauseRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGClassDefinition #(#IllAnalyzer)) #'2024-08-28T17:11:58.976696+02:00') )
]
