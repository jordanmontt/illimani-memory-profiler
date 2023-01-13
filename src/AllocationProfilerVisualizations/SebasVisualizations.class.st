"
Soy una clase cool que muestra visualizaciones
"
Class {
	#name : #SebasVisualizations,
	#superclass : #Object,
	#instVars : [
		'allocations'
	],
	#category : #AllocationProfilerVisualizations
}

{ #category : #defaults }
SebasVisualizations >> addLabelsX: xText y: yText ForChart: chart [

	(chart xlabel: xText) shape
		color: Color black;
		fontFamily: 'Impact'.
	(chart ylabel: yText) shape
		color: Color black;
		fontFamily: 'Impact'
]

{ #category : #accessing }
SebasVisualizations >> allocations: aCollection [

	allocations := aCollection
]

{ #category : #visualization }
SebasVisualizations >> barChartClassesCanvas [

	| chart names objectsCreated x |
	objectsCreated := self occurrencesByMethodClass.
	names := objectsCreated collect: [ :e | e key name ].
	x := 1 to: objectsCreated size.
	chart := self createBarChartFor: objectsCreated x: x.
	self addLabelsX: 'Classes' y: 'Number of Created Objects' ForChart: chart.
	chart build.
	^ chart canvas
]

{ #category : #defaults }
SebasVisualizations >> createBarChartFor: objectsCreated x: x [

	| chart barPlot |
	chart := RSChart new.
	barPlot := RSBarPlot new x: x y: (objectsCreated collect: #value).
	chart addPlot: barPlot.
	self tuneBarChart: chart for: objectsCreated.
	^ chart
]

{ #category : #defaults }
SebasVisualizations >> createLinePlotForAllocations: someAllocations [

	| times linePlot values |
	"The times are in nano seconds"
	times := someAllocations collect: [ :each | each timestamp asNanoSeconds ].
	"To start in 0"
	times := times - allocations first timestamp asNanoSeconds.
	values := 1 to: times size.

	linePlot := RSLinePlot new x: times y: values.
	^ linePlot
]

{ #category : #visualization }
SebasVisualizations >> numberOfAllocatedObjectsPerSecondLineChartCanvas [

	| chart linePlot |
	linePlot := self createLinePlotForAllocations: allocations.
	chart := RSChart new.
	chart add: linePlot.
	self tuneChartForLinePlot: chart.
	chart build.
	
	linePlot line @ RSPopup.
	^ chart canvas
]

{ #category : #visualization }
SebasVisualizations >> numberOfAllocatedObjectsPerSecondPerClassLineChartCanvas [

	| chart classGroups linePlot sortedGroupKeys legend |
	classGroups := allocations groupedBy: [ :holder | holder context methodClass ].
	sortedGroupKeys := classGroups keys sorted: [ :key1 :key2 | 
		(classGroups at: key1) size > (classGroups at: key2) size ].
	sortedGroupKeys := sortedGroupKeys first: (3 min: classGroups keys size).
	
	chart := RSChart new.
	legend := RSLegend new.
	legend container: chart canvas.
	sortedGroupKeys do: [ :class | 
		| subAllocations  |
		subAllocations := classGroups at: class.
		linePlot := self createLinePlotForAllocations: subAllocations.
		chart add: linePlot.
		legend text: class name withBoxColor: linePlot computeColor ].
	
	self tuneChartForLinePlot: chart.
	
	legend location
		middle;
		right.
	legend legendDo: [ :l | l
		borderColor: 'black';
		scaleBy: 0.5;
		padding: 10 ].
	
	chart build.
	legend build.
	
	^ chart canvas
]

{ #category : #defaults }
SebasVisualizations >> occurrencesBy: aBlock [

	| objectsCreated ocurrences |
	objectsCreated := OrderedCollection new.
	ocurrences := Bag newFrom: (allocations collect: aBlock).
	ocurrences doWithOccurrences: [ :key :value | objectsCreated add: key -> value ].
	^ objectsCreated sorted: [ :a :b | a value > b value ]
]

{ #category : #defaults }
SebasVisualizations >> occurrencesByMethod [

	^ self occurrencesBy: [ :e | e context asString ]
]

{ #category : #defaults }
SebasVisualizations >> occurrencesByMethodClass [

	^ self occurrencesBy: [ :e | e context methodClass ]
]

{ #category : #visualization }
SebasVisualizations >> topClassesThatAllocateObjectsBarChartCanvas [

	| chart names objectsCreated x |
	objectsCreated := self occurrencesByMethodClass first: (10 min: self occurrencesByMethodClass size).
	names := objectsCreated collect: [ :e | e key name ].
	x := 1 to: objectsCreated size.
	
	chart := self createBarChartFor: objectsCreated x: x.
	self addLabelsX: 'Classes' y: 'Number of Created Objects' ForChart: chart.
	chart build.
	^ chart canvas
]

{ #category : #visualization }
SebasVisualizations >> topMethodsThatAllocateObjectsBarChartCanvas [

	| chart names objectsCreated x |
	objectsCreated := self occurrencesByMethod first: (10 min: self occurrencesByMethodClass size).
	names := objectsCreated collect: [ :e | e ].
	x := 1 to: objectsCreated size.

	chart := self createBarChartFor: objectsCreated x: x.
	self addLabelsX: 'Methods' y: 'Number of Created Objects' ForChart: chart.
	chart build.
	^ chart canvas
]

{ #category : #defaults }
SebasVisualizations >> tuneBarChart: chart for: objectsCreated [

	chart add: RSVerticalTick new.
	chart addDecoration: (RSHorizontalTick new
			 useVerticalLabel;
			 fromNames: objectsCreated;
			 yourself)
]

{ #category : #defaults }
SebasVisualizations >> tuneChartForLinePlot: chart [

	chart add: (RSHorizontalTick new
			 labelConversion: [ :number | (number / (10 raisedTo: 9)) asFloat ];
			 yourself).
	chart add: RSVerticalTick new.
	self addLabelsX: 'Seconds' y: 'Number of Created Objects' ForChart: chart
]
