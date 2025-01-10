Class {
	#name : 'IllAnalyzer',
	#superclass : 'Object',
	#instVars : [
		'pretenurator',
		'allocationSiteStrategy',
		'allocationSiteClassificator',
		'objectAllocations',
		'toPretenureSites'
	],
	#category : 'IllimaniProfiler-Analyzer',
	#package : 'IllimaniProfiler',
	#tag : 'Analyzer'
}

{ #category : 'instance creation' }
IllAnalyzer class >> onProfiler: aProfiler [

	^ self new
		  setForProfiler: aProfiler;
		  yourself
]

{ #category : 'accessing' }
IllAnalyzer >> allocationSiteStrategy: aStrategy [

	allocationSiteStrategy := aStrategy
]

{ #category : 'api' }
IllAnalyzer >> analyze [

	| allocationSendersList |
	self removeKernelAllocations.
	self identifyAllocationSites.
	self classifyAllocationSites.
	self removeMisclassifiedSites.
	1 halt.

	allocationSendersList := toPretenureSites values collect: [ :allocSiteBin |
		allocSiteBin allObjects first allocationSenders asMethodWithOffsetObjects ].
	pretenurator pretenureAllocations: allocationSendersList
]

{ #category : 'api' }
IllAnalyzer >> classifyAllocationSites [

	toPretenureSites := allocationSiteClassificator retrievePretenureSites.
	^ toPretenureSites
]

{ #category : 'calculating' }
IllAnalyzer >> identifyAllocationSites [

	allocationSiteStrategy identifyAllocationSites: objectAllocations.
]

{ #category : 'initialization' }
IllAnalyzer >> initialize [

	super initialize.

	allocationSiteClassificator := IllAllocationSiteClassificator new.
	pretenurator := IllPretenurator new.
	allocationSiteStrategy := TextualLocationOfNewStrategy new
]

{ #category : 'removing' }
IllAnalyzer >> removeKernelAllocations [

	objectAllocations removeAllSuchThat: [ :illEphemeron |
		{
			Context.
			Deprecation.
			Process.
			WeakArray } includes: illEphemeron allocatedObjectClass ]
]

{ #category : 'api' }
IllAnalyzer >> removeMisclassifiedSites [

	toPretenureSites := allocationSiteStrategy removeMisclassifiedSites: toPretenureSites.
	^ toPretenureSites
]

{ #category : 'initialization' }
IllAnalyzer >> setForProfiler: aProfiler [

	objectAllocations := aProfiler objectAllocations copy.
	allocationSiteClassificator
		objectAllocations: objectAllocations;
		endTime: aProfiler endTime;
		startTime: aProfiler startTime
]
