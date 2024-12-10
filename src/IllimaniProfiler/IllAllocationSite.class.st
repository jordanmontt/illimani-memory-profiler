"
I am a model that represents an allocation site: the allocator method and the byte of the bytecode that sends the message. 

For example:, for this method

```st
SequenceableCollection >> #copyFrom: start to: stop
	""Answer a copy of a subset of the receiver, starting from element at
	index start until element at index stop.""

	| newSize |
	newSize := stop - start + 1.
	^(self species new: newSize)
		replaceFrom: 1
		to: newSize
		with: self
		startingAt: start
```

The allocation site is the the byte 50 (that corresponds to the `send: new:` bytecode) in the method `SequenceableCollection >> #copyFrom: start to: stop`.
"
Class {
	#name : 'IllAllocationSite',
	#superclass : 'Object',
	#instVars : [
		'method',
		'byte'
	],
	#category : 'IllimaniProfiler-Analyzer',
	#package : 'IllimaniProfiler',
	#tag : 'Analyzer'
}

{ #category : 'instance creation' }
IllAllocationSite class >> method: method byte: byte [

	^ self new
		  method: method;
		  byte: byte;
		  yourself
]

{ #category : 'comparing' }
IllAllocationSite >> = anObj [

	self class = anObj class ifFalse: [ ^ false ].
	^ method = anObj method
		and: [ byte = anObj byte ]
]

{ #category : 'accessing' }
IllAllocationSite >> byte [
	^ byte
]

{ #category : 'accessing' }
IllAllocationSite >> byte: anInteger [ 
	byte := anInteger
]

{ #category : 'comparing' }
IllAllocationSite >> hash [

	| hash |
	hash := method hash.
	hash := hash * 486187739 + byte hash.
	^ hash
]

{ #category : 'inspecting' }
IllAllocationSite >> inspectionSource [

	<inspectorPresentationOrder: 30 title: 'Allocation site'>
	^ self inspectorPresenter
]

{ #category : 'inspecting' }
IllAllocationSite >> inspectorPresenter [

	| codePresenter |
	codePresenter := IllMethodHighlightedBytecodePresenterInspection new
		                 method: method;
		                 offset: byte;
		                 buildPresenter.
	^ SpPresenter new
		  layout: (SpBoxLayout newTopToBottom
				   add: (SpLabelPresenter new
						    label: 'Method implemented in:';
						    yourself)
				   expand: false;
				   add: (SpTextPresenter new
						    text: method methodClass name;
						    beNotEditable;
						    yourself)
				   expand: false;
				   add: (SpLabelPresenter new
						    label: 'Method code:';
						    yourself)
				   expand: false;
				   add: codePresenter expand: true;
				   yourself);
		  yourself
]

{ #category : 'accessing' }
IllAllocationSite >> method [
	^ method
]

{ #category : 'accessing' }
IllAllocationSite >> method: aCollection [ 
	method := aCollection
]

{ #category : 'printing' }
IllAllocationSite >> printOn: aStream [

	method printOn: aStream.
	aStream << ' at byte: '.
	byte printOn: aStream
]
