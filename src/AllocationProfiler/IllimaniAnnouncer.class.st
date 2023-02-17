"
I am an announcer that users can subscribe to me to listen to my annoucements.
"
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
