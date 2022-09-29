"
I am a handler that register when a color is created. I keep that of both the color and the creation context
"
Class {
	#name : #MpColorAllocationProfilerHandler,
	#superclass : #MpObjectAllocationProfilerHandler,
	#category : #MethodProxiesSebas
}

{ #category : #evaluating }
MpColorAllocationProfilerHandler >> classToRegister [

	^ Color
]

{ #category : #initialization }
MpColorAllocationProfilerHandler >> customClassesToAvoid [

	^ { 
		Color class.
		Color }
]