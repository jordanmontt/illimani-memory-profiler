Class {
	#name : 'GCLogger',
	#superclass : 'Object',
	#instVars : [
		'fullGCs',
		'scavengers',
		'process',
		'waitingTime'
	],
	#category : 'IllimaniProfiler-Model-Statistics',
	#package : 'IllimaniProfiler',
	#tag : 'Model-Statistics'
}

{ #category : 'initialization' }
GCLogger >> initialize [

	super initialize.
	fullGCs := OrderedCollection new: 10000.
	scavengers := OrderedCollection new: 10000.
	waitingTime := 1 second
]

{ #category : 'api' }
GCLogger >> registerStats [

	fullGCs add: Smalltalk vm fullGCCount.
	scavengers add: Smalltalk vm incrementalGCCount
]

{ #category : 'api' }
GCLogger >> run [

	process := [
		[ true ] whileTrue: [
			self registerStats.
			waitingTime wait ] ] fork
]

{ #category : 'api' }
GCLogger >> run: aCodeBlock [

	process := [
		[ true ] whileTrue: [
			self registerStats.
			waitingTime wait ] ] fork.
	
	aCodeBlock ensure: [ process terminate ]
]

{ #category : 'api' }
GCLogger >> terminate [

	process terminate
]

{ #category : 'accessing' }
GCLogger >> waitingTime: aDuration [

	waitingTime := aDuration
]
