"
Soy una clase cool que muestra visualizaciones
"
Class {
	#name : #SebasVisualizations,
	#superclass : #Object,
	#instVars : [
		'allocations'
	],
	#category : #SebasVisualizations
}

{ #category : #accessing }
SebasVisualizations >> allocations: aCollection [ 
	allocations := aCollection
]

{ #category : #visualization }
SebasVisualizations >> barChart [

	| chart barPlot ocurrences names y x |
	names := OrderedCollection new.
	y := OrderedCollection new.
	ocurrences := Bag newFrom: (allocations collect: [:e | e context methodClass]).
	ocurrences doWithOccurrences: [ :key : value |
		y add: value.
		names add: key name ].
	x := 1 to: names size.

	chart := RSChart new.
	barPlot := RSBarPlot new x: x y: y.

	chart addPlot: barPlot.
	chart add: RSVerticalTick new.
	chart addDecoration: (RSHorizontalTick new
		useVerticalLabel;
		fromNames: names;
		yourself).

	chart build.
	barPlot bars @ RSPopup.
	^ chart canvas
]
