Class {
	#name : 'IllAllocatorMethodsConstant',
	#superclass : 'Object',
	#classVars : [
		'Arobas',
		'ArrayClass',
		'BasicNew',
		'BasicNewKeyword',
		'Clone',
		'CompiledCodeClone',
		'Copy',
		'ExternalAddressClone',
		'FixedBitWidthRegisterCopy',
		'IntervalNew',
		'NewPinned',
		'NewPinnedKeyword',
		'NewTenured',
		'NewTenuredKeyword'
	],
	#category : 'Illimani-FrameworkProfiler-Instrumentation',
	#package : 'Illimani-FrameworkProfiler',
	#tag : 'Instrumentation'
}

{ #category : 'class initialization' }
IllAllocatorMethodsConstant class >> allocatorCompiledPrimitiveMethods [

    ^ self classVariables collect: #value
]

{ #category : 'class initialization' }
IllAllocatorMethodsConstant class >> initialize [

	"Basic new primitives"
	BasicNew := Behavior >> #basicNew.
	BasicNewKeyword := Behavior >> #basicNew:.
	NewPinned := Behavior >> #basicNewPinned .
	NewPinnedKeyword := Behavior >> #basicNewPinned:.
	
	"Tenured primitives"
	NewTenured := Behavior >> #basicNewTenured .
	NewTenuredKeyword := Behavior >> #basicNewTenured:.

	"Specialized primitives"
	ArrayClass := Array class lookupSelector: #new:.
	IntervalNew := Interval class >> #new.
	Arobas  := Number >> #@.

	"Copy and clone primitives"
	Copy := Object >> #shallowCopy.
	Clone := Object >> #clone.
	CompiledCodeClone := CompiledCode >> #clone.
	ExternalAddressClone := ExternalAddress >> #clone.
	FixedBitWidthRegisterCopy := FixedBitWidthRegister >> #copy
]
