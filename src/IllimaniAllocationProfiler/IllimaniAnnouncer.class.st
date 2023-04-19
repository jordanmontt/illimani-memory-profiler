Class {
	#name : #IllimaniAnnouncer,
	#superclass : #Announcer,
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'IllimaniAllocationProfiler-Announcements'
}

{ #category : #accessing }
IllimaniAnnouncer class >> uniqueInstance [

	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
]
