"
I am a subclass of Roassal RSDSM presenter. I am a subclass because I define specific behavior for coloring the matrix and calculating the labels
"
Class {
	#name : 'HeatmapRoassalBuilder',
	#superclass : 'RSDSM',
	#instVars : [
		'scale',
		'data',
		'colorPaletteList',
		'dataDomain'
	],
	#category : 'IllimaniUI-Roassal',
	#package : 'IllimaniUI',
	#tag : 'Roassal'
}

{ #category : 'hooks' }
HeatmapRoassalBuilder >> computeColor: aTuple [

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

{ #category : 'hooks' }
HeatmapRoassalBuilder >> data: someData [

	| allocatedSortedClasses |
	data := someData.
	self initializeColorMultilinearScale.

	self objectsY: (data collect: [ :e | e allocator name]).

	allocatedSortedClasses := Dictionary new.
	data do: [ :e | e groupedAllocations keysAndValuesDo: [ :k :v |
		allocatedSortedClasses at: k update: [ :old | old + v size] initial: v size ] ].
	allocatedSortedClasses := allocatedSortedClasses associations
		sorted: [ :a :b | a value > b value ].
	self objectsX: (allocatedSortedClasses collect: #key).

	self shape @ (RSPopup new text: [ :tuple |
		 tuple key asString , ' allocated ' , (self numberFor: tuple) asString
		 , ' instances of ' , tuple value asString ])
]

{ #category : 'initialization' }
HeatmapRoassalBuilder >> initialize [

	super initialize.
	self setShouldFeedY.
	colorPaletteList :=  {
		"beige" (Color fromHexString: 'FFFFFD').
		"yellow" (Color fromHexString: 'f4ff76').
		"orange" (Color fromHexString: 'ff9000').
		"red" (Color fromHexString: 'cc0000').
		Color black }
]

{ #category : 'hooks' }
HeatmapRoassalBuilder >> initializeColorMultilinearScale [

	| maxDataDomain |
	maxDataDomain := (data collect: [ :tuple | tuple value totalAllocations ]) max.
	dataDomain := {
		         0.
		         (maxDataDomain / 4) asInteger.
		         (maxDataDomain / 2) asInteger.
		         (maxDataDomain * 3 / 4) asInteger.
		         maxDataDomain }.
	scale := NSScale linear
		         clamp: true;
		         domain: dataDomain;
		         range: colorPaletteList;
		         yourself
]

{ #category : 'hooks' }
HeatmapRoassalBuilder >> labelX [

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

{ #category : 'hooks' }
HeatmapRoassalBuilder >> labelY [

	| labelY |
	labelY := RSLabel new
		fontSize: 15;
		color: Color black;
		rotateByDegrees: -90;
		text: 'Allocators';
		yourself.
	RSLocation new
		outer;
		left;
		middle;
		move: labelY on: labelsY asGroup.
	^ labelY
]

{ #category : 'hooks' }
HeatmapRoassalBuilder >> numberFor: tuple [

	| allocator allocatedClass index |
	allocator := tuple key.
	allocatedClass := tuple value.
	index := data findFirst: [ :node | node allocator name = allocator ].
	^ (data at: index) allocationsOf: allocatedClass
]

{ #category : 'rendering' }
HeatmapRoassalBuilder >> renderIn: aCanvas [

	| labelY labelX |
	super renderIn: aCanvas.

	labelY := self labelY.
	aCanvas add: labelY.

	labelX := self labelX.
	aCanvas add: labelX.

	self renderLegend: aCanvas
]

{ #category : 'hooks' }
HeatmapRoassalBuilder >> renderLegend: aCanvas [

	| box percentages paint legend boxScale lastColumn |
	lastColumn := (self columnAt: objectsX size) asGroup.
	box := RSBox new.
	box extent: lastColumn extent.

	percentages := 0 to: 1 count: colorPaletteList size.
	paint := LinearGradientPaint fromArray:
		         (percentages with: colorPaletteList
			          collect: [ :per :color | per asFloat -> color ]).

	paint start: box baseRectangle topLeft.
	paint stop: box baseRectangle bottomLeft.
	box paint: paint.
	box border: (RSBorder new color: 'black').
	legend := RSGroup new.
	legend add: box.
	boxScale := NSScale linear range: {
			            box baseRectangle topRight.
			            box baseRectangle bottomRight }.
	percentages with: dataDomain do: [ :per :value |
		| line label point |
		point := boxScale scale: per.
		line := RSLine new
			        startPoint: point;
			        endPoint: point + (5 @ 0);
			        color: 'black';
			        yourself.
		label := RSLabel new
			         text: value;
			         color: 'black';
			         fontSize: 6;
			         yourself.
		label position: point + (7 @ 0) + (label width / 2 @ 0).
		legend
			add: line;
			add: label ].
	legend := legend asShape.
	RSLocation new
		outer;
		middle;
		right;
		offset: 20 @ 0;
		move: legend on: lastColumn.
	aCanvas add: legend
]
