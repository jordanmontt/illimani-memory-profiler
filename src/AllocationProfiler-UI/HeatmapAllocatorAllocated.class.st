"
I am a subclass of Roassal RSDSM presenter. I am a subclass because I define specific behavior for coloring the matrix and calculating the labels
"
Class {
	#name : #HeatmapAllocatorAllocated,
	#superclass : #RSDSM,
	#instVars : [
		'scale',
		'data'
	],
	#category : #'AllocationProfiler-UI'
}

{ #category : #hooks }
HeatmapAllocatorAllocated >> computeColor: aTuple [

	"| aNumber |
	aNumber := self numberFor: aTuple.
	^ aNumber isZero ifTrue: [ Color veryVeryLightGray ]
		  ifFalse: [ scale scale: aNumber ]"
	^ scale scale: (self numberFor: aTuple)
]

{ #category : #hooks }
HeatmapAllocatorAllocated >> data: someData [

	| numbers |
	data := someData.
	numbers := data collect: [ :tuple | tuple value totalAllocations ].
	"{ Color green alphaMixed: 0.2 with: Color white }"
	scale := NSScale linear
		domain: { 0 . numbers max };
		clamp: true;
		range: {Color fromHexString: 'ADD8E6' . Color red }.

	self objectsY: (data collect: #key).
	"x values are allocated classes"
	self objectsX: (data flatCollect: [ :tuple | tuple value allocations keys ] as: Set).

	self shape @ (RSPopup new text: [ :tuple |
		 tuple key asString , ' allocated ' , (self numberFor: tuple) asString
		 , ' instances of ' , tuple value asString ])
]

{ #category : #initialization }
HeatmapAllocatorAllocated >> initialize [

	super initialize.
	self setShouldFeedY
]

{ #category : #hooks }
HeatmapAllocatorAllocated >> numberFor: tuple [

	| allocatorClass allocatedClass obj |
	allocatorClass := tuple key.
	allocatedClass := tuple value.
	obj := data detect: [ :each | each key = allocatorClass ].
	^ obj value allocationsOf: allocatedClass
]

{ #category : #hooks }
HeatmapAllocatorAllocated >> renderIn: aCanvas [

	| labelY labelX |
	super renderIn: aCanvas.
	labelY := RSLabel new
		          fontSize: 15;
		          color: Color black;
		          rotateByDegrees: -90;
		          text: 'Top Allocators';
		          yourself.
	RSLocation new
		outer;
		left;
		middle;
		move: labelY on: labelsY asGroup.
	aCanvas add: labelY.

	labelX := RSLabel new
		          fontSize: 15;
		          color: Color black;
		          text: 'Allocated';
		          yourself.
	RSLocation new
		bottom;
		outer;
		move: labelX on: (self rowAt: objectsY size) asGroup.
	aCanvas add: labelX
]
