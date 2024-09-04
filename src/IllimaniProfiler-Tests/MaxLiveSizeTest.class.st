Class {
	#name : 'MaxLiveSizeTest',
	#superclass : 'TestCase',
	#instVars : [
		'mockedObjectAllocations'
	],
	#category : 'IllimaniProfiler-Tests-Analyzer',
	#package : 'IllimaniProfiler-Tests',
	#tag : 'Analyzer'
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
		sizeInBytes: 10;
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
		sizeInBytes: 100;
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
		sizeInBytes: 40;
		key: #m;
		yourself.

	mockedObjectAllocations := { a .b .c .d .e .f .g .h .i .j .k .l .m } sorted: [ :v1 :v2 | v1 initializationTime < v2 initializationTime ]
]

{ #category : 'tests' }
MaxLiveSizeTest >> testMaxLiveSize [

	| analyzer |
	analyzer := IllAnalyzer new
		objectAllocations: mockedObjectAllocations;
		yourself.

	self assert: analyzer maxLiveSize equals: 140 "j and m are the only alive objects at point 13 of the timeline. J weights 100 bytes and m 40"
]
