Class {
	#name : #IllimaniAnnouncer,
	#superclass : #Announcer,
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'AllocationProfiler-Announcements'
}

{ #category : #accessing }
IllimaniAnnouncer class >> uniqueInstance [

	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
]
