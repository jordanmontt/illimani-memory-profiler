Class {
	#name : 'IllPredictator',
	#superclass : 'Object',
	#instVars : [
		'objectAllocations',
		'predictors'
	],
	#category : 'IllimaniProfiler-Analyzer',
	#package : 'IllimaniProfiler',
	#tag : 'Analyzer'
}

{ #category : 'as yet unclassified' }
IllPredictator >> computePredictors [

	predictors := Dictionary new.

	objectAllocations do: [ :illEphe |
		predictors
			at: illEphe allocationSite
			ifPresent: [ :predictor |
				predictor
					addLifetime: illEphe lifetime;
					addType: illEphe allocatedObjectClass ]
			ifAbsentPut: [
				IllPredictor new
					allocationSite: illEphe allocationSite;
					addLifetime: illEphe lifetime;
					addType: illEphe allocatedObjectClass ] ]
]

{ #category : 'accessing' }
IllPredictator >> objectAllocations: aCollection [

	objectAllocations := aCollection
]
