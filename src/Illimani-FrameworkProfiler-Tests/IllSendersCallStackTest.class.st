"
An IllSendersCallStackTest is a test class for testing the behavior of IllSendersCallStack
"
Class {
	#name : 'IllSendersCallStackTest',
	#superclass : 'TestCase',
	#category : 'Illimani-FrameworkProfiler-Tests-Utilities',
	#package : 'Illimani-FrameworkProfiler-Tests',
	#tag : 'Utilities'
}

{ #category : 'tests' }
IllSendersCallStackTest >> testSendersAreDifferent [

    | senders1 senders2 |
    senders1 := IllSendersCallStack new
	     senders: { OrderedCollection>> #add: . 1 . Object >> #yourself . 10 . Behavior>> #basicNew . 20 };
        yourself.
    senders2 := IllSendersCallStack new
	     senders: { OrderedCollection>> #add: . 12 . Object >> #yourself . 10 . Behavior>> #basicNew . 20 };
        yourself.
    self deny: senders1 equals: senders2
]

{ #category : 'tests' }
IllSendersCallStackTest >> testTwoSendersWithSameCallStackAreEqual [

    | senders1 senders2 |
    senders1 := IllSendersCallStack new
	     senders: { OrderedCollection>> #add: . 1 . Object >> #yourself . 10 . Behavior>> #basicNew . 20 };
        yourself.
    senders2 := IllSendersCallStack new
	     senders: { OrderedCollection>> #add: . 1 . Object >> #yourself . 10 . Behavior>> #basicNew . 20 };
        yourself.
    self assert: senders1 equals: senders2
]
