Class {
	#name : 'MaxLiveSizeTest',
	#superclass : 'TestCase',
	#instVars : [
		'mockedObjectAllocations'
	],
	#category : 'IllimaniProfiler-Tests-Model-Statistics',
	#package : 'IllimaniProfiler-Tests',
	#tag : 'Model-Statistics'
}

{ #category : 'running' }
MaxLiveSizeTest >> setUp [

	| a b c d e f g h i j k l m initialTime |
	super setUp.
	initialTime := Time primUTCMicrosecondsClock.
	a := IllEphemeron new
		initializationTime: (initialTime + 1000000);
		finalizationTime: (initialTime + 2000000);
		sizeInBytes: 10;
		key: #a;
		yourself.
	b := IllEphemeron new
		initializationTime: (initialTime + 2000000);
		finalizationTime: (initialTime + 6000000);
		sizeInBytes: 10;
		key: #b;
		yourself.
	c := IllEphemeron new
		initializationTime: (initialTime + 4000000);
		finalizationTime: (initialTime + 9000000);
		sizeInBytes: 10;
		key: #c;
		yourself.
	d := IllEphemeron new
		initializationTime: (initialTime + 5000000);
		finalizationTime: (initialTime + 6000000);
		sizeInBytes: 10;
		key: #d;
		yourself.
	e := IllEphemeron new
		initializationTime: (initialTime + 3000000);
		finalizationTime: (initialTime + 11000000);
		sizeInBytes: 10;
		key: #e;
		yourself.
	f := IllEphemeron new
		initializationTime: (initialTime + 4000000);
		finalizationTime: (initialTime + 7000000);
		sizeInBytes: 10;
		key: #f;
		yourself.
	g := IllEphemeron new
		initializationTime: (initialTime + 5000000);
		finalizationTime: (initialTime + 6000000);
		sizeInBytes: 15;
		key: #g;
		yourself.
	h := IllEphemeron new
		initializationTime: (initialTime + 5000000);
		finalizationTime: (initialTime + 6000000);
		sizeInBytes: 10;
		key: #h;
		yourself.
	i := IllEphemeron new
		initializationTime: (initialTime + 8000000);
		finalizationTime: (initialTime + 12000000);
		sizeInBytes: 10;
		key: #i;
		yourself.
	j := IllEphemeron new
		initializationTime: (initialTime + 13000000);
		finalizationTime: (initialTime + 16000000);
		sizeInBytes: 10;
		key: #j;
		yourself.
	k := IllEphemeron new
		initializationTime: (initialTime + 14000000);
		finalizationTime: (initialTime + 16000000);
		sizeInBytes: 10;
		key: #k;
		yourself.
	l := IllEphemeron new
		initializationTime: (initialTime + 15000000);
		finalizationTime: (initialTime + 16000000);
		sizeInBytes: 10;
		key: #l;
		yourself.
	m := IllEphemeron new
		initializationTime: (initialTime + 11000000);
		finalizationTime: (initialTime + 14000000);
		sizeInBytes: 10;
		key: #m;
		yourself.

	mockedObjectAllocations := { a .b .c .d .e .f .g .h .i .j .k .l .m }
]

{ #category : 'tests' }
MaxLiveSizeTest >> testClassify [

	| analyzer |
	analyzer := IllAnalyzer new
		objectAllocations: mockedObjectAllocations;
		yourself.

	self assert: analyzer maxLiveSize equals: 7
]

{ #category : 'tests' }
MaxLiveSizeTest >> testMaxLiveSize [

	| analyzer |
	analyzer := IllAnalyzer new
		objectAllocations: mockedObjectAllocations;
		yourself.

	"There are 7 objects with a size of 10 except one that has 15 of size"
	self assert: analyzer maxLiveSize equals: 75
]
