Class {
	#name : 'IllAbstractProfiler',
	#superclass : 'Object',
	#instVars : [
		'samplingCounter',
		'samplingRate',
		'handler',
		'proxyBasicNew',
		'proxyBasicNewKeyword',
		'proxyArrobas',
		'proxyArrayClass',
		'vmStats',
		'totalTime',
		'startTime',
		'proxyCopy'
	],
	#category : 'IllimaniProfiler-Instrumentation',
	#package : 'IllimaniProfiler',
	#tag : 'Instrumentation'
}

{ #category : 'accessing - statistics' }
IllAbstractProfiler >> allocatedMemoryRatePerSecond [

	^ self stats totalAllocatedMemory
	  / (Duration microSeconds: totalTime) totalSeconds asFloat
]

{ #category : 'accessing - statistics' }
IllAbstractProfiler >> allocationRatePerSecond [

	^ self stats totalAllocatedObjects
	  / (Duration microSeconds: totalTime) totalSeconds asFloat
]

{ #category : 'accessing - statistics' }
IllAbstractProfiler >> beginningOfProfilingTime [

	^ startTime
]

{ #category : 'api' }
IllAbstractProfiler >> forceUninstall [
	"Warning, do not use unless you cannot start the profiler because you have the
	MpCannotInstall exception"

	MpMethodProxy allInstances do: #uninstall
]

{ #category : 'accessing' }
IllAbstractProfiler >> illimaniAnnouncer [

	^ IllAnnouncer new
]

{ #category : 'initialization' }
IllAbstractProfiler >> initialize [

	super initialize.
	handler := IllMpHandler new
		profiler: self;
		yourself.
	self initializeMethodProxies: handler.
	samplingCounter := 0.
	samplingRate := 100
]

{ #category : 'initialization' }
IllAbstractProfiler >> initializeMethodProxies: aHandler [

	proxyBasicNew := MpMethodProxy onMethod: Behavior >> #basicNew handler: aHandler.
	proxyBasicNewKeyword := MpMethodProxy onMethod: Behavior >> #basicNew: handler: aHandler.

	"Not wrapping the method Number>>#@ because it's always by far the must allocator method and
	it pollutes the results."
	proxyArrobas := MpNullMethodProxy onMethod: Number >> #@ handler: aHandler.
	
	proxyCopy := MpMethodProxy onMethod: Object >> #shallowCopy handler: aHandler. 
	proxyArrayClass := MpMethodProxy onMethod: Array class >> #new: handler: aHandler
]

{ #category : 'profiling' }
IllAbstractProfiler >> initializeVMStats [

	startTime := Time primUTCMicrosecondsClock.
	vmStats := Smalltalk vm getParameters
]

{ #category : 'profiling' }
IllAbstractProfiler >> installMethodProxies [

	proxyBasicNew install.
	proxyBasicNewKeyword install.
	proxyArrobas install.
	proxyArrayClass install.
	proxyCopy install
]

{ #category : 'profiling' }
IllAbstractProfiler >> internalRegisterAllocation: anObject [

	^ self subclassResponsibility
]

{ #category : 'testing' }
IllAbstractProfiler >> isProfilingFinished [

	^ totalTime isNotNil
]

{ #category : 'testing' }
IllAbstractProfiler >> isProfilingStarted [

	^ startTime isNotNil
]

{ #category : 'accessing' }
IllAbstractProfiler >> objectAllocations [

	^ self subclassResponsibility
]

{ #category : 'api' }
IllAbstractProfiler >> profileFor: aDuration [
	"Done with a fork because we don't want to block the ui thread since it allocates objects. "

	self startProfiling.
	[
	(Delay forDuration: aDuration) wait.
	self stopProfiling ] fork
]

{ #category : 'api' }
IllAbstractProfiler >> profileOn: aBlock [

	self startProfiling.
	"The nil at the end is necessary because else the value of the block is referenced inside
	the ensure: method. We don't want to keep the reference because it avoids the object from
	being garbage collected"
	[
	aBlock value.
	nil ] ensure: [ self stopProfiling ]
]

{ #category : 'profiling' }
IllAbstractProfiler >> registerAllocation: anObject [

	samplingRate = 100 ifTrue: [
		"Sampling 100% capture all"
		self internalRegisterAllocation: anObject.
		^ self ].

	samplingCounter := samplingCounter + 1.
	samplingCounter > 100 ifTrue: [ samplingCounter := 1 ].

	samplingCounter <= samplingRate
		ifTrue: [ self internalRegisterAllocation: anObject ]
		ifFalse: [ ^ self ]
]

{ #category : 'accessing - statistics' }
IllAbstractProfiler >> reportGCStatsOn: stream [

	| oldSpaceEnd youngSpaceEnd memoryEnd fullGCs fullGCTime incrGCs incrGCTime tenureCount upTime rootOverflows |
	upTime := totalTime.
	oldSpaceEnd := vmStats at: 1.
	youngSpaceEnd := vmStats at: 2.
	memoryEnd := vmStats at: 3.
	fullGCs := vmStats at: 7.
	fullGCTime := vmStats at: 8.
	incrGCs := vmStats at: 9.
	incrGCTime := vmStats at: 10.
	tenureCount := vmStats at: 11.
	rootOverflows := vmStats at: 22.

	stream	nextPutAll: '**Memory**'; cr.
	stream	nextPutAll:	'	old	 space        ';
		nextPutAll: oldSpaceEnd humanReadableByteSizeString; cr.
	stream	nextPutAll: '	young space    ';
		nextPutAll: (youngSpaceEnd - oldSpaceEnd) humanReadableByteSizeString; cr.
	stream	nextPutAll: '	used                    ';
		nextPutAll: youngSpaceEnd humanReadableByteSizeString; cr.
	stream	nextPutAll: '	freed                   ';
		nextPutAll: (youngSpaceEnd - memoryEnd) humanReadableByteSizeString; cr.

	stream cr.
	stream	nextPutAll: '**GCs**'; cr.
	stream	nextPutAll: '	full			';
		print: fullGCs; nextPutAll: ' totalling '; nextPutAll: fullGCTime asStringWithCommas; nextPutAll: 'ms (';
		print: ((fullGCTime / upTime * 100) roundTo: 1.0);
		nextPutAll: '% uptime)'.
	fullGCs = 0 ifFalse:
		[stream	nextPutAll: ', avg '; print: ((fullGCTime / fullGCs) roundTo: 1.0); nextPutAll: 'ms'].
	stream	cr.
	stream	nextPutAll: '	incr	    	         ';
		print: incrGCs; nextPutAll: ' totalling '; nextPutAll: incrGCTime asStringWithCommas; nextPutAll: 'ms (';
		print: ((incrGCTime / upTime * 100) roundTo: 1.0);
		nextPutAll: '% uptime)'.
	incrGCs = 0 ifFalse:
		[stream nextPutAll:', avg '; print: ((incrGCTime / incrGCs) roundTo: 1.0); nextPutAll: 'ms'].
	stream cr.
	stream	nextPutAll: '	tenures		';
		nextPutAll: tenureCount asStringWithCommas.
	tenureCount = 0 ifFalse:
		[stream nextPutAll: ' (avg '; print: (incrGCs / tenureCount) asInteger; nextPutAll: ' GCs/tenure)'].
	stream	cr.
	stream	nextPutAll: '	root table	';
		nextPutAll: rootOverflows asStringWithCommas; nextPutAll:' overflows'.
	stream cr
]

{ #category : 'accessing - statistics' }
IllAbstractProfiler >> reportProcessStatsOn: aStream [

	| totalSwitches pageOverflows pageDivorces  |
	vmStats size >= 61 ifFalse: [ ^ self ]. "don't try this on the closure VM"
	totalSwitches := vmStats at: 56.
	pageOverflows := vmStats at: 60.
	pageDivorces := vmStats at: 61.

	aStream cr; nextPutAll: '**Processes**'; cr.
	aStream tab; nextPutAll: 'Total process switches:   '; nextPutAll: totalSwitches printString; cr.

	aStream tab; nextPutAll: 'Stack page overflows:      '; nextPutAll: pageOverflows printString; cr.
	aStream tab; nextPutAll: 'Stack page divorces:        '; nextPutAll: pageDivorces printString
]

{ #category : 'accessing - statistics' }
IllAbstractProfiler >> reportVMStats [

	^ String streamContents: [ :stream |
		self reportGCStatsOn: stream.
		self reportProcessStatsOn: stream ]
]

{ #category : 'accessing' }
IllAbstractProfiler >> samplingRate [

	^ samplingRate
]

{ #category : 'api' }
IllAbstractProfiler >> samplingRate: anInteger [
	"The anInteger needs to be an integer number between 1 and 100. This number represents the
	sampling rate *percentage*"

	samplingRate := anInteger
]

{ #category : 'profiling' }
IllAbstractProfiler >> startProfiling [

	self installMethodProxies.
	self initializeVMStats
]

{ #category : 'accessing - statistics' }
IllAbstractProfiler >> stats [

	^ self subclassResponsibility
]

{ #category : 'profiling' }
IllAbstractProfiler >> stopProfiling [

	self uninstallMethodProxies.
	self updateVMStats
]

{ #category : 'accessing - statistics' }
IllAbstractProfiler >> totalProfiledTime [

	^ totalTime
]

{ #category : 'profiling' }
IllAbstractProfiler >> uninstallMethodProxies [

	proxyBasicNew uninstall.
	proxyBasicNewKeyword uninstall.
	proxyArrobas uninstall.
	proxyArrayClass uninstall.
	proxyCopy uninstall
]

{ #category : 'profiling' }
IllAbstractProfiler >> updateVMStats [

	totalTime := Time primUTCMicrosecondsClock - startTime.
	Smalltalk vm getParameters keysAndValuesDo: [ :idx :value |
		value isInteger ifTrue: [ vmStats at: idx put: value - ((vmStats at: idx) ifNil: [ 0 ]) ] ]
]
