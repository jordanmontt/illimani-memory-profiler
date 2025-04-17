Extension { #name : 'Behavior' }

{ #category : '*Illimani-Pharo12-Compatibility' }
Behavior >> basicNewTenured [
	"Primitive. Allocates the object in the old space. Answers the allocated object.
	
	See more information in the newTenured method comment."

	<primitive: 596 error: ec>
	ec == #'insufficient object memory' ifTrue: [
		^ self handleFailingBasicNewTenured ].
	self isVariable ifTrue: [ ^ self basicNewTenured: 0 ].
	self primitiveFailed
]

{ #category : '*Illimani-Pharo12-Compatibility' }
Behavior >> basicNewTenured: sizeRequested [
	"Primitive. Allocates the object in the old space. Answers the allocated object.
	
	See more information in the newTenured method comment."

	<primitive: 597 error: ec>
	ec == #'insufficient object memory' ifTrue: [
		^ self handleFailingBasicNewTenured: sizeRequested ].
	self isVariable ifFalse: [
		self error: self printString , ' cannot have variable sized instances' ].
	self primitiveFailed
]

{ #category : '*Illimani-Pharo12-Compatibility' }
Behavior >> handleFailingBasicNewTenured [
	"handleFailingBasicNew gets sent after basicNew has failed and allowed
	 a scavenging garbage collection to occur.  The scavenging collection
	 will have happened as the VM is activating the (failing) basicNew.  If
	 handleFailingBasicNew fails then the scavenge failed to reclaim sufficient
	 space and a global garbage collection is required.  Retry after garbage
	 collecting and growing memory if necessary.

	 Primitive. Answer an instance of this class with the number of indexable
	 variables specified by the argument, sizeRequested.  Fail if this class is not
	 indexable or if the argument is not a positive Integer, or if there is not
	 enough memory available. Essential. See Object documentation whatIsAPrimitive."

	<primitive: 596>
	Smalltalk garbageCollect < 1048576 ifTrue: [ Smalltalk growMemoryByAtLeast: 1048576 ].
	^ self handleFailingFailingBasicNewTenured "retry after global garbage collect"
]

{ #category : '*Illimani-Pharo12-Compatibility' }
Behavior >> handleFailingBasicNewTenured: sizeRequested [
	"handleFailingBasicNew: gets sent after basicNew: has failed and allowed
	 a scavenging garbage collection to occur.  The scavenging collection
	 will have happened as the VM is activating the (failing) basicNew:.  If
	 handleFailingBasicNew: fails then the scavenge failed to reclaim sufficient
	 space and a global garbage collection is required.  Retry after garbage
	 collecting and growing memory if necessary.

	 Primitive. Answer an instance of this class with the number of indexable
	 variables specified by the argument, sizeRequested.  Fail if this class is not
	 indexable or if the argument is not a positive Integer, or if there is not
	 enough memory available. Essential. See Object documentation whatIsAPrimitive."

	<primitive: 597>
	| bytesRequested |
	bytesRequested := self byteSizeOfInstanceOfSize: sizeRequested.
	^ Smalltalk garbageCollect < bytesRequested
		  ifTrue: [
			  Smalltalk growMemoryByAtLeast: bytesRequested
			  "retry after global garbage collect and possible grow".
			  self handleFailingFailingBasicNewTenured: sizeRequested ]
		  ifFalse: [ self handleFailingBasicNewTenuredWithGC: sizeRequested ]
]

{ #category : '*Illimani-Pharo12-Compatibility' }
Behavior >> handleFailingBasicNewTenuredWithGC: sizeRequested [
	"handleFailingBasicNewWithGC: gets sent after basicNew: has failed, a GC has been	performed and the allocation still fails even though enough memory was reported 	as available. Given that this has happened when there is plenty of virtual memory available, assume that the GC has reported incorrectly and try one more time anyway.	 Primitive. Answer an instance of this class with the number of indexable	 variables specified by the argument, sizeRequested.  Fail if this class is not	 indexable or if the argument is not a positive Integer, or if there is not	 enough memory available. Essential. See Object documentation whatIsAPrimitive."

	<primitive: 597>
	| bytesRequested |
	bytesRequested := self byteSizeOfInstanceOfSize: sizeRequested.
	Smalltalk growMemoryByAtLeast: bytesRequested.
	^ self handleFailingFailingBasicNewTenured: sizeRequested
]

{ #category : '*Illimani-Pharo12-Compatibility' }
Behavior >> handleFailingFailingBasicNewTenured [
	"This basicNew gets sent after handleFailingBasicNew: has done a full
	 garbage collection and possibly grown memory.  If this basicNew fails
	 then the system really is low on space, so raise the OutOfMemory signal.

	 Primitive. Answer an instance of this class with the number of indexable
	 variables specified by the argument, sizeRequested.  Fail if this class is not
	 indexable or if the argument is not a positive Integer, or if there is not
	 enough memory available. Essential. See Object documentation whatIsAPrimitive."

	"space must be low"

	<primitive: 596>
	OutOfMemory signal.
	^ self basicNewTenured "retry if user proceeds"
]

{ #category : '*Illimani-Pharo12-Compatibility' }
Behavior >> handleFailingFailingBasicNewTenured: sizeRequested [
	"This basicNew: gets sent after handleFailingBasicNew: has done a full
	 garbage collection and possibly grown memory.  If this basicNew: fails
	 then the system really is low on space, so raise the OutOfMemory signal.

	 Primitive. Answer an instance of this class with the number of indexable
	 variables specified by the argument, sizeRequested.  Fail if this class is not
	 indexable or if the argument is not a positive Integer, or if there is not
	 enough memory available. Essential. See Object documentation whatIsAPrimitive."

	<primitive: 597>
	"space must be low."
	OutOfMemory signal.
	^self basicNewTenured: sizeRequested  "retry if user proceeds"
]

{ #category : '*Illimani-Pharo12-Compatibility' }
Behavior >> newTenured [
	"Allocates the object directly in the old space. This is useful when you know
	that you have an object that will live for a long time. It saves the garbage collector
	from moving the object from different memory positions when it is in the young space and
	then moving the object to the old space (a.k.a. tenuring).  It gives the power to the user
	to do memory optimizations, such as pre-tenuring.
	Use with caution. Keep in mind that the garbage collector is optimized when the allocations
	are made in the new space, that why the new space exists.
	Use this method when you know that tenuring the object is what you want."

	^ self basicNewTenured initialize
]

{ #category : '*Illimani-Pharo12-Compatibility' }
Behavior >> newTenured: sizeRequested [
	"Allocates the variable size object in the old space. See newTenured comment for more
	information."

	^ (self basicNewTenured: sizeRequested) initialize
]
