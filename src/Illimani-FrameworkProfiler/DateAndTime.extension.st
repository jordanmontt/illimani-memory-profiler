Extension { #name : 'DateAndTime' }

{ #category : '*Illimani-FrameworkProfiler' }
DateAndTime >> asStringYMDHMS [

	^ String streamContents: [ :aStream |
		| year month day |
		"Date"
		self dayMonthYearDo: [ :d :m :y | year := y. month := m. day := d ].
		day printOn: aStream base: 10 length: 2 padded: true.
		aStream nextPut: $-.
		month printOn: aStream base: 10 length: 2 padded: true.
		aStream nextPut: $-.
		(year \\ 100) printOn: aStream base: 10 length: 2 padded: true.
		"Time"
		aStream nextPut: $T.
		self printHMSOn: aStream separatedBy: $. ]
]
