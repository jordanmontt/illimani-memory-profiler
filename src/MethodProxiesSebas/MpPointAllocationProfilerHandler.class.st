Class {
	#name : #MpPointAllocationProfilerHandler,
	#superclass : #MpObjectAllocationProfilerHandler,
	#category : #MethodProxiesSebas
}

{ #category : #evaluating }
MpPointAllocationProfilerHandler >> classToRegister [

	^ Point
]

{ #category : #initialization }
MpPointAllocationProfilerHandler >> customClassesToAvoid [

	^ { 
		Point.
		Point class }
]
