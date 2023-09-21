Class {
	#name : 'MpNullMethodProxy',
	#superclass : 'Object',
	#category : 'IllimaniKernel',
	#package : 'IllimaniKernel'
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
