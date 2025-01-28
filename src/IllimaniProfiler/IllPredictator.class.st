"
Experiment to implement the algorithm for predicting object lifetimes.

Paper:

Object Lifetime Prediction in Java
Hajime Inoue, Darko Stefanovic, Stephanie Forrest
"
Class {
	#name : 'IllPredictator',
	#superclass : 'Object',
	#instVars : [
		'objectAllocations',
		'predictors'
	],
	#category : 'IllimaniProfiler-Experiments',
	#package : 'IllimaniProfiler',
	#tag : 'Experiments'
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

{ #category : 'initialization' }
IllPredictator >> setForProfiler: aProfiler [

	self objectAllocations: aProfiler objectAllocations
]
