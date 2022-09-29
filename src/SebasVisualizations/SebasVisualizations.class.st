"
Soy una clase cool que muestra visualizaciones
"
Class {
	#name : #SebasVisualizations,
	#superclass : #Object,
	#instVars : [
		'names',
		'y',
		'x'
	],
	#category : #SebasVisualizations
}

{ #category : #visualization }
SebasVisualizations >> barChart [

	| chart barPlot |
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

{ #category : #accessing }
SebasVisualizations >> names [

	^ names
]

{ #category : #accessing }
SebasVisualizations >> names: anObject [

	names := anObject
]

{ #category : #accessing }
SebasVisualizations >> x [

	^ x
]

{ #category : #accessing }
SebasVisualizations >> x: anObject [

	x := anObject
]

{ #category : #accessing }
SebasVisualizations >> y [

	^ y
]

{ #category : #accessing }
SebasVisualizations >> y: anObject [

	y := anObject
]
