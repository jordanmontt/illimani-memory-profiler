Class {
	#name : #MpNullMethodProxy,
	#superclass : #MpMethodProxy,
	#pools : [
		'MpMethodProxyPool'
	],
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
