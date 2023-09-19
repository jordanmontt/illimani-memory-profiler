Extension { #name : 'IllimaniFinalizationProfiler' }

{ #category : '*IllimaniAllocationProfiler-UI' }
IllimaniFinalizationProfiler >> densityChart [

	|  groupedData x dictionary y |
	groupedData := (self objectAllocations groupedBy: [ :allocationModel |
		                allocationModel lifetimeAsDuration asSeconds ]) associations.
	groupedData sort: [ :a :b | a key < b key ].

	x := 0 to: groupedData last key asInteger.
	dictionary := Dictionary newFrom: groupedData.
	"y := x collect: [ :index |
	dictionary at: index
	ifPresent: [ :collection | collection size ]
	ifAbsent: [ 0 ] ]."
	y := x collect: [ :index |
		     dictionary at: index
			     ifPresent: [ :collection | collection sum: #totalSizeInBytes ]
			     ifAbsent: [ 0 ] ].

	^ IllimaniDensityDistributionChart new
		  x: x;
		  y: y;
		  xTitle: 'Lifetime in seconds';
		  "yTitle: 'Number of objects (log scale)';"yTitle: 'Memory (log scale)';
		  title: '';
		  densityChartCanvas
]

{ #category : '*IllimaniAllocationProfiler-UI' }
IllimaniFinalizationProfiler >> open [

	^ (IllimaniFinalizationProfilerUI profiler: self announcer: IllimaniAnnouncer new)
		  open;
		  yourself
]
