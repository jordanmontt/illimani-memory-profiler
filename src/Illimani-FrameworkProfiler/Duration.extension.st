Extension { #name : 'Duration' }

{ #category : '*Illimani-FrameworkProfiler' }
Duration >> asDeciSeconds [


 	^ ((seconds * NanosInSecond) + nanos) // (10 raisedToInteger: 8)
]

{ #category : '*Illimani-FrameworkProfiler' }
Duration >> humanReadableStringWithOnlySeconds [

	^ String streamContents: [ :out | self printHumanReadableStringWithOnlySecondsOn: out ]
]

{ #category : '*Illimani-FrameworkProfiler' }
Duration >> printHumanReadableStringWithOnlySecondsOn: stream [

	self negative ifTrue: [
		stream << '- '.
		^ self abs printHumanReadableStringWithOnlySecondsOn: stream ].

	stream
		<< (self totalSeconds printShowingDecimalPlaces: 3)
		<< String space
		<< ('second' asPluralBasedOn: self totalSeconds)
]
