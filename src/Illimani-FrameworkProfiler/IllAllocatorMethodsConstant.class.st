Class {
	#name : 'IllAllocatorMethodsConstant',
	#superclass : 'Object',
	#instVars : [
		'basicNewKeyword',
		'newPinned',
		'newPinnedKeyword',
		'newTenured',
		'newTenuredKeyword',
		'arrayClass',
		'arobas',
		'copy',
		'clone',
		'compiledCodeClone',
		'externalAddressClone',
		'fixedBitWidthRegisterCopy',
		'basicNew',
		'intervalNew'
	],
	#category : 'Illimani-FrameworkProfiler-Instrumentation',
	#package : 'Illimani-FrameworkProfiler',
	#tag : 'Instrumentation'
}

{ #category : 'initialization' }
IllAllocatorMethodsConstant >> allocatorCompiledMethods [

	^ (1 to: self class slots size) collect: [ :index | self instVarAt: index ]
]

{ #category : 'initialization' }
IllAllocatorMethodsConstant >> initialize [

	super initialize.

	"Basic new primitives"
	basicNew := Behavior >> #basicNew.
	basicNewKeyword := Behavior >> #basicNew:.
	newPinned := Behavior >> #basicNewPinned .
	newPinnedKeyword := Behavior >> #basicNewPinned:.
	
	"Tenured primitives"
	newTenured := Behavior >> #basicNewTenured .
	newTenuredKeyword := Behavior >> #basicNewTenured:.

	"Specialized primitives"
	arrayClass := Array class lookupSelector: #new:.
	intervalNew := Interval class >> #new.
	arobas  := Number >> #@.

	"Copy and clone primitives"
	copy := Object >> #shallowCopy.
	clone := Object >> #clone.
	compiledCodeClone := CompiledCode >> #clone.
	externalAddressClone := ExternalAddress >> #clone.
	fixedBitWidthRegisterCopy := FixedBitWidthRegister >> #copy
]
