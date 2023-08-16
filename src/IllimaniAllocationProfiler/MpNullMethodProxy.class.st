Class {
	#name : #MpNullMethodProxy,
	#superclass : #MpMethodProxy,
	#category : #'IllimaniAllocationProfiler-Profiler Instrumentator'
}

{ #category : #installation }
MpNullMethodProxy >> install [
]

{ #category : #installation }
MpNullMethodProxy >> shouldWrap: aMethod [

	^ false
]

{ #category : #installation }
MpNullMethodProxy >> uninstall [
]
