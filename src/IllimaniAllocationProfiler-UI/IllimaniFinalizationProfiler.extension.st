Extension { #name : #IllimaniFinalizationProfiler }

{ #category : #'*IllimaniAllocationProfiler-UI' }
IllimaniFinalizationProfiler >> palu4 [

	| groupingBlock yTransformingBlock groupedData x dictionary y |
	groupingBlock := [ :allocationModel |
	                 allocationModel lifetimeAsDuration asSeconds ].
	"yTransformingBlock := [ :collection | collection size ]."
	yTransformingBlock := [ :collection | collection sum: #totalSizeInBytes ].

	groupedData := (self objectAllocations groupedBy: [ :collection | groupingBlock value: collection ])
		               associations.
	groupedData sort: [ :a :b | a key < b key ].

	x := 0 to: groupedData last key asInteger.
	dictionary := Dictionary newFrom: groupedData.
	y := x collect: [ :index |
		     dictionary at: index
			     ifPresent: [ :collection | yTransformingBlock value: collection ]
			     ifAbsent: [ 0 ] ].

	^ IllimaniDistributionForFinalization new
		x: x;
		y: y;
		xTitle: 'Lifetime in seconds';
		yTitle: 'Memory (log scale)';
		title: 'Object''s lifetime Profile Loading a 500MB DataFrame';
		palu4
]
