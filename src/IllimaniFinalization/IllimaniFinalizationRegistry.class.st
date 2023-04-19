"
(https://github.com/pharo-project/pheps/blob/main/phep-0003.md)
"
Class {
	#name : #IllimaniFinalizationRegistry,
	#superclass : #FinalizationRegistry,
	#category : #IllimaniFinalization
}

{ #category : #accessing }
IllimaniFinalizationRegistry >> default [

	^ Default ifNil: [ Default := FinalizationRegistry new ]
]
