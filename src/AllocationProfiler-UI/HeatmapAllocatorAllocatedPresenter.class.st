"
I am a subclass of Roassal RSDSM presenter. I am a subclass because I define specific behavior for coloring the matrix and calculating the labels
"
Class {
	#name : #HeatmapAllocatorAllocatedPresenter,
	#superclass : #RSDSM,
	#instVars : [
		'scale',
		'data'
	],
	#category : #'AllocationProfiler-UI'
}

{ #category : #hooks }
HeatmapAllocatorAllocatedPresenter >> computeColor: aTuple [

	| aNumber |
	aNumber := self numberFor: aTuple.
	^ aNumber isZero ifTrue: [ Color veryVeryLightGray ]
		  ifFalse: [ scale scale: aNumber ]
]

{ #category : #hooks }
HeatmapAllocatorAllocatedPresenter >> data: someData [

	| numbers |
	data := someData.
	numbers := data collect: [ :tuple | tuple value totalAllocations ].
	"{ Color green alphaMixed: 0.2 with: Color white }"
	scale := NSScale linear
		domain: {numbers min. numbers max};
		clamp: true;
		range: {Color green alphaMixed: 0.2 with: Color white . Color green alphaMixed: 0.2 with: Color black}.

	self objectsY: (data collect: #key).
	"x values are allocated classes"
	self objectsX: (data flatCollect: [ :tuple | tuple value allocations keys ] as: Set).

	self shape @ (RSPopup new text: [:tuple |
		tuple key asString, ' allocated ',
		(self numberFor: tuple) asString, ' instances of ',
		tuple value asString
		   ])
]

{ #category : #initialization }
HeatmapAllocatorAllocatedPresenter >> initialize [

	super initialize.
	self setShouldFeedY.
	self rotation: 90
]

{ #category : #hooks }
HeatmapAllocatorAllocatedPresenter >> numberFor: tuple [

	| allocatorClass allocatedClass obj |
	allocatorClass := tuple key.
	allocatedClass := tuple value.
	obj := data detect: [ :each | each key = allocatorClass ].
	^ obj value allocationsOf: allocatedClass
]
