Extension { #name : 'Duration' }

{ #category : '*IllimaniUI' }
Duration >> humanReadableStringWithOnlySeconds [

	^ String streamContents: [ :out | self printHumanReadableStringWithOnlySecondsOn: out ]
]

{ #category : '*IllimaniUI' }
Duration >> printHumanReadableStringWithOnlySecondsOn: stream [

	self negative ifTrue: [
		stream << '- '.
		^ self abs printHumanReadableStringWithOnlySecondsOn: stream ].

	stream
		<< (self totalSeconds printShowingDecimalPlaces: 3)
		<< String space
		<< ('second' asPluralBasedOn: self totalSeconds)
]
