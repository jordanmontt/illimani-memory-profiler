"
I am a class that builds the canvas of the different visualizations.
"
Class {
	#name : #AllocationVisualizations,
	#superclass : #Object,
	#instVars : [
		'allocations',
		'numberOfTopClasses',
		'numberOfTopMethods'
	],
	#category : #AllocationProfilerVisualizations
}

{ #category : #'chart construction' }
AllocationVisualizations >> addLabelsX: xText y: yText forChart: chart [

	(chart xlabel: xText) shape
		color: Color black.
		"fontFamily: 'Impact'."
	(chart ylabel: yText) shape
		color: Color black.
]

{ #category : #visualizations }
AllocationVisualizations >> allocatedObjectsPerSecondLineChartCanvas [

	| chart linePlot |
	linePlot := self createLinePlotForAllocations: allocations.
	chart := RSChart new.
	chart add: linePlot.
	self tuneChartForLinePlot: chart.
	chart build.
	^ chart canvas
]

{ #category : #visualizations }
AllocationVisualizations >> allocatedObjectsPerSecondPerClassLineChartCanvas [

	| chart linePlot topClassesByNumberOfAllocations legend |
	topClassesByNumberOfAllocations := self calculateTopAllocatingClasses.
	chart := RSChart new.
	legend := RSLegend new.
	legend container: chart canvas.
	topClassesByNumberOfAllocations do: [ :aPair | 
		linePlot := self createLinePlotForAllocations: aPair value.
		chart add: linePlot.
		legend text: aPair key name withBoxColor: linePlot computeColor ].

	self tuneChartForLinePlot: chart.
	self tuneLegend: legend.
	chart build.
	legend build.
	^ chart canvas
]

{ #category : #accessing }
AllocationVisualizations >> allocations: aCollection [

	allocations := aCollection
]

{ #category : #visualizations }
AllocationVisualizations >> barChartClassesCanvas [

	| chart names allocatedObjects  |
	allocatedObjects := self occurrencesByClass.
	names := allocatedObjects collect: [ :e | e key name ].

	chart := self createBarChartForAllocations: allocatedObjects.
	self addLabelsX: 'Classes' y: 'Allocated Objects' forChart: chart.
	chart build.
	^ chart canvas
]

{ #category : #'chart construction' }
AllocationVisualizations >> calculateTopAllocatingClasses [

	| classesWithTheirAllocations topClassesByNumberOfAllocations |
	classesWithTheirAllocations := allocations groupedBy: [ :holder | holder context methodClass ].
	
	topClassesByNumberOfAllocations := classesWithTheirAllocations keys sorted: [ :key1 :key2 | 
		(classesWithTheirAllocations at: key1) size > (classesWithTheirAllocations at: key2) size ].
	topClassesByNumberOfAllocations := topClassesByNumberOfAllocations first:
		(numberOfTopClasses min: classesWithTheirAllocations keys size).
	
	^ topClassesByNumberOfAllocations collect: [ :each | each -> (classesWithTheirAllocations at: each) ]	
]

{ #category : #'chart construction' }
AllocationVisualizations >> createBarChartForAllocations: allocatedObjects [

	| chart barPlot indices |
	chart := RSChart new.
	indices := 1 to: allocatedObjects size.
	barPlot := RSHorizontalBarPlot new x: (allocatedObjects collect: #value) y: indices.
	chart addPlot: barPlot.
	self tuneBarChart: chart forNames: (allocatedObjects collect: #key).
	^ chart
]

{ #category : #'chart construction' }
AllocationVisualizations >> createLinePlotForAllocations: someAllocations [

	| times linePlot indices |
	"The times are in nano seconds"
	times := someAllocations collect: [ :each | each timestamp asNanoSeconds ].
	"To start in 0"
	times := times - allocations first timestamp asNanoSeconds.
	indices := 1 to: times size.

	linePlot := RSLinePlot new x: times y: indices.
	^ linePlot
]

{ #category : #initialization }
AllocationVisualizations >> initialize [ 

	super initialize.
	numberOfTopClasses := 10.
	numberOfTopMethods := 10
]

{ #category : #'chart construction' }
AllocationVisualizations >> occurrencesBy: aBlock [

	| objectsCreated ocurrences |
	objectsCreated := OrderedCollection new.
	ocurrences := Bag newFrom: (allocations collect: aBlock).
	ocurrences doWithOccurrences: [ :key :value | objectsCreated add: key -> value ].
	^ objectsCreated sorted: [ :a :b | a value < b value ]
]

{ #category : #'chart construction' }
AllocationVisualizations >> occurrencesByClass [

	^ self occurrencesBy: [ :e | e context methodClass ]
]

{ #category : #'chart construction' }
AllocationVisualizations >> occurrencesByMethod [

	^ self occurrencesBy: [ :e | e context asString ]
]

{ #category : #accessing }
AllocationVisualizations >> topClasses: anInteger [

	numberOfTopClasses := anInteger
]

{ #category : #visualizations }
AllocationVisualizations >> topClassesThatAllocateObjectsBarChartCanvas [

	| chart names allocatedObjects |
	allocatedObjects := self occurrencesByClass first: (numberOfTopClasses min: self occurrencesByClass size).
	names := allocatedObjects collect: [ :e | e key name ].
	
	chart := self createBarChartForAllocations: allocatedObjects.
	self addLabelsX: 'Number of Created Objects' y: 'Classes' forChart: chart.
	chart build.
	^ chart canvas
]

{ #category : #accessing }
AllocationVisualizations >> topMethods: anInteger [

	numberOfTopMethods := anInteger
]

{ #category : #visualizations }
AllocationVisualizations >> topMethodsThatAllocateObjectsBarChartCanvas [

	| chart names allocatedObjects |
	allocatedObjects := self occurrencesByMethod first: (numberOfTopMethods min: self occurrencesByClass size).
	names := allocatedObjects collect: [ :e | e asString ].

	chart := self createBarChartForAllocations: allocatedObjects.
	self addLabelsX: 'Number of Created Objects' y: 'Methods' forChart: chart.
	chart build.
	^ chart canvas
]

{ #category : #'chart construction' }
AllocationVisualizations >> tuneBarChart: chart forNames: allocatedObjectNames [

	chart add:( RSHorizontalTick new
		useNiceLabel;
		yourself).
	chart addDecoration: (RSVerticalTick new
		fromNames: allocatedObjectNames;
		yourself).
		
	chart padding: 5
]

{ #category : #'chart construction' }
AllocationVisualizations >> tuneChartForLinePlot: chart [

	chart add: (RSHorizontalTick new
		"Divide by 10^9 because the time is in nanoseconds"
		labelConversion: [ :number | (number / (10 raisedTo: 9)) asFloat ];
		yourself).
	chart add: RSVerticalTick new.
	self addLabelsX: 'Seconds' y: 'Allocated Objects' forChart: chart
]

{ #category : #'chart construction' }
AllocationVisualizations >> tuneLegend: legend [

	legend location
		middle;
		right.
	legend legendDo: [ :l | 
		l
			borderColor: 'black';
			scaleBy: 0.5;
			padding: 10 ]
]
