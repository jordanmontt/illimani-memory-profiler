"
I am a subclass of Roassal RSDSM presenter. I am a subclass because I define specific behavior for coloring the matrix and calculating the labels
"
Class {
	#name : #HeatmapAllocatorAllocated,
	#superclass : #RSDSM,
	#instVars : [
		'scale',
		'data',
		'colorPaletteList',
		'range'
	],
	#category : #'AllocationProfiler-UI'
}

{ #category : #hooks }
HeatmapAllocatorAllocated >> computeColor: aTuple [

	^ scale scale: (self numberFor: aTuple)
	"| aNumber |
	""code for getting fixed colors and not scaleting them""
	aNumber := self numberFor: aTuple.
	aNumber = 0 ifTrue: [ ^ scale range first ].
	aNumber < scale domain second ifTrue: [ ^ scale range second ].
	aNumber < scale domain third ifTrue: [ ^ scale range third ].
	aNumber < scale domain fourth ifTrue: [ ^ scale range fourth ].
	^ scale range fifth"
]

{ #category : #hooks }
HeatmapAllocatorAllocated >> data: someData [

	data := someData.
	self initializeColorMultilinearScale.

	self objectsY: (data collect: #key).
	self objectsX: (data flatCollect: [ :tuple | tuple value allocations keys ] as: Set).

	self shape @ (RSPopup new text: [ :tuple |
		 tuple key asString , ' allocated ' , (self numberFor: tuple) asString
		 , ' instances of ' , tuple value asString ])
]

{ #category : #initialization }
HeatmapAllocatorAllocated >> initialize [

	super initialize.
	self setShouldFeedY.
	colorPaletteList :=  {
		"beige" (Color fromHexString: 'FFFFFD').
		"yellow" (Color fromHexString: 'f4ff76').
		"orange" (Color fromHexString: 'ff9000').
		"red" (Color fromHexString: 'cc0000').
		Color black }
]

{ #category : #hooks }
HeatmapAllocatorAllocated >> initializeColorMultilinearScale [

	| numberOfAllocationsSorted |
	numberOfAllocationsSorted := (data flatCollect: [ :tuple | tuple value eachAllocationsTotal ])
		sorted: [ :a :b | a < b ].

	range :=  { "We dive the allocations into 5 equal parts. First the smallest and at the end the biggest"
		0.
		numberOfAllocationsSorted first.
		(numberOfAllocationsSorted at: (numberOfAllocationsSorted size / 3) asInteger).
		(numberOfAllocationsSorted at: (numberOfAllocationsSorted size * 2 / 3) asInteger).
		numberOfAllocationsSorted last }.
	scale := NSScale linear
		clamp: true;
		domain: range;
		range: colorPaletteList
]

{ #category : #hooks }
HeatmapAllocatorAllocated >> labelX [

	| labelX |
	labelX := RSLabel new
		fontSize: 15;
		color: Color black;
		text: 'Allocated';
		yourself.
	RSLocation new
		bottom;
		outer;
		move: labelX on: (self rowAt: objectsY size) asGroup.
	^ labelX
]

{ #category : #hooks }
HeatmapAllocatorAllocated >> labelY [

	| labelY |
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
	^ labelY
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

	labelY := self labelY.
	aCanvas add: labelY.

	labelX := self labelX.
	aCanvas add: labelX.

	self renderLegend: aCanvas
]

{ #category : #hooks }
HeatmapAllocatorAllocated >> renderLegend: aCanvas [

	| legend |
	legend := RSLegend new.
	legend
		text: range first asString withBoxColor: colorPaletteList first;
		text: range second asString , '-' , (range third - 1) asString
		withBoxColor: colorPaletteList second;
		text: range third asString , '-' , (range fourth - 1) asString
		withBoxColor: colorPaletteList third;
		text: range fourth asString , '-' , (range fifth - 1) asString
		withBoxColor: colorPaletteList fourth;
		text: range fifth asString withBoxColor: colorPaletteList fifth.

	legend container: aCanvas.
	legend build
]
