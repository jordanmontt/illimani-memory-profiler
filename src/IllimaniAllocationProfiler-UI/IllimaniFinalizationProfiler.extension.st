Extension { #name : #IllimaniFinalizationProfiler }

{ #category : #'*IllimaniAllocationProfiler-UI' }
IllimaniFinalizationProfiler >> palu4 [

	| groupingBlock groupedData x dictionary y |
	groupingBlock := [ :allocationModel |
	                 allocationModel lifetimeAsDuration asSeconds ].

	groupedData := (self objectAllocations groupedBy: [ :collection | groupingBlock value: collection ])
		               associations.
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

	^ IllimaniDistributionForFinalization new
		x: x;
		y: y;
		xTitle: 'Lifetime in seconds';
		"yTitle: 'Number of objects (log scale)';"
		yTitle: 'Memory (log scale)';
		title: '';
		palu4
]
