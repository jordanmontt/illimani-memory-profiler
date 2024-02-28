Class {
	#name : 'IllAllocationSiteExporterTest',
	#superclass : 'IllAbstractExporterTest',
	#category : 'IllimaniProfiler-Tests',
	#package : 'IllimaniProfiler-Tests'
}

{ #category : 'asserting' }
IllAllocationSiteExporterTest >> assertCSVContent: csvReader [

	| line |
	line := csvReader next.
	self assert: (line first asClassInEnvironment: Smalltalk globals) isClass.
	self assert: line second asInteger equals: 100. "size"
	self assert: line third asInteger > 100000000.
	self assert: (line fourth asClassInEnvironment: Smalltalk globals) isClass.
	self assert: line last isString "method name"
]

{ #category : 'tests' }
IllAllocationSiteExporterTest >> expectedCSVHeader [

	^ #( #allocatedObjectClass #sizeInBytes #initializationTimeInMicroSeconds
	     #allocatorClass #allocatorMethod )
]

{ #category : 'exporting' }
IllAllocationSiteExporterTest >> exporterClass [

	^ IllAllocationSiteExporter
]

{ #category : 'running' }
IllAllocationSiteExporterTest >> fakeAllocations [

	| allocatedClasses allocatorClasses |
	allocatedClasses := 'Kernel' asPackage definedClasses asArray first: 10.
	allocatorClasses := 'Kernel' asPackage definedClasses asArray last: 10.
	^ (1 to: 1000) collect: [ :i | AllocationSiteInfoModel new
		allocatedObjectClass: allocatedClasses atRandom;
		allocatorClass: allocatorClasses atRandom;
		allocatorMethod: Collection>>#sorted:;
		sizeInBytes: 100;
		yourself ]
]
