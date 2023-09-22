Class {
	#name : 'MpNullMethodProxy',
	#superclass : 'Object',
	#category : 'IllimaniProfiler-Instrumentation',
	#package : 'IllimaniProfiler',
	#tag : 'Instrumentation'
}

{ #category : 'instance creation' }
MpNullMethodProxy class >> onMethod: aMethod handler: aHandler [

	^ self new
]

{ #category : 'installation' }
MpNullMethodProxy >> install [
]

{ #category : 'installation' }
MpNullMethodProxy >> shouldWrap: aMethod [

	^ false
]

{ #category : 'installation' }
MpNullMethodProxy >> uninstall [
]
