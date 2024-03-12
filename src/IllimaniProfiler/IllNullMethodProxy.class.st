Class {
	#name : 'IllNullMethodProxy',
	#superclass : 'Object',
	#category : 'IllimaniProfiler-Instrumentation',
	#package : 'IllimaniProfiler',
	#tag : 'Instrumentation'
}

{ #category : 'instance creation' }
IllNullMethodProxy class >> onMethod: aMethod handler: aHandler [

	^ self new
]

{ #category : 'installation' }
IllNullMethodProxy >> install [
]

{ #category : 'installation' }
IllNullMethodProxy >> shouldWrap: aMethod [

	^ false
]

{ #category : 'installation' }
IllNullMethodProxy >> uninstall [
]
