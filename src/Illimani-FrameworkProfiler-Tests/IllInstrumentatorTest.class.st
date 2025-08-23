"
An IllInstrumentatorTest is a test class for testing the behavior of IllInstrumentator
"
Class {
	#name : 'IllInstrumentatorTest',
	#superclass : 'TestCase',
	#category : 'Illimani-FrameworkProfiler-Tests-Instrumentation',
	#package : 'Illimani-FrameworkProfiler-Tests',
	#tag : 'Instrumentation'
}

{ #category : 'tests' }
IllInstrumentatorTest >> testProxyVariables [

    self assert: (IllInstrumentator onProfiler: nil) proxyVariables size equals: (IllInstrumentator slots size - 2)
]
