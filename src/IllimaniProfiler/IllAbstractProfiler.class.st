"
I am the abstract class that proviedes infrastructure for all the profilers. You can subclass me to craft your own custom profiler. You can see my subclasses as examples of custom profilers.

- Sampling rate: I have a default sampling rate for capturing the allocations, so I do not capture the 100% of allocations by default.
- Exporting: I can export my data in form of json and csv. I can export the metadata and the raw allocations.
- GUI: I also provide a GUI that the users can use to navigate my data. But, I can be fully used without the GUI too.
- GC logger: I also provide a garbage collector logger that logs the GC activity one per second and then exports the data. By default, the logger is a null object, so it doesn't log anything by default.
- VM statistics and statistics in general
- Announcement when the profiling has stopped: I make an announcement when the profiler has finished profiling.
"
Class {
	#name : 'IllAbstractProfiler',
	#superclass : 'Object',
	#instVars : [
		'samplingCounter',
		'samplingRate',
		'vmStats',
		'startTime',
		'profiledCode',
		'gcActivityMonitor',
		'illimaniAnnouncer',
		'instrumentator',
		'endTime'
	],
	#category : 'IllimaniProfiler-Profiler',
	#package : 'IllimaniProfiler',
	#tag : 'Profiler'
}

{ #category : 'announcements' }
IllAbstractProfiler >> announceProfilerStopedProfiling [

	illimaniAnnouncer announce: IllStopedProfilingAnnouncement
]

{ #category : 'accessing' }
IllAbstractProfiler >> endTime [

	^ endTime
]

{ #category : 'exporting' }
IllAbstractProfiler >> exportData [
	"This exports BOTH the metadata AND the raw allocations"

	(self exporterClass on: self) exportData
]

{ #category : 'exporting' }
IllAbstractProfiler >> exportMetaData [
	"This exports ONLY the medata data, not the raw allocations"

	(self exporterClass on: self) exportMetaData
]

{ #category : 'exporting' }
IllAbstractProfiler >> exporterClass [

	^ self subclassResponsibility
]

{ #category : 'api' }
IllAbstractProfiler >> forceUninstall [

	instrumentator forceUninstall
]

{ #category : 'accessing' }
IllAbstractProfiler >> gcActivityMonitor [

	^ gcActivityMonitor
]

{ #category : 'accessing' }
IllAbstractProfiler >> illimaniAnnouncer [

	^ illimaniAnnouncer
]

{ #category : 'initialization' }
IllAbstractProfiler >> initialize [

	super initialize.
	illimaniAnnouncer := IllAnnouncer new.
	instrumentator := IllInstrumentator onProfiler: self.
	samplingCounter := 0.
	self samplingRate: 1/100.
	gcActivityMonitor := IllNullGCActivityMonitor new
]

{ #category : 'profiling' }
IllAbstractProfiler >> initializeVMStats [

	"startTime := Time primUTCMicrosecondsClock."
	startTime := Smalltalk vm parameterAt: 34.
	vmStats := Smalltalk vm getParameters
]

{ #category : 'profiling' }
IllAbstractProfiler >> instrument [

	instrumentator instrument
]

{ #category : 'profiling' }
IllAbstractProfiler >> internalRegisterAllocation: anObject [

	^ self subclassResponsibility
]

{ #category : 'testing' }
IllAbstractProfiler >> isProfilingFinished [

	^ endTime isNotNil
]

{ #category : 'testing' }
IllAbstractProfiler >> isProfilingStarted [

	^ startTime isNotNil
]

{ #category : 'api' }
IllAbstractProfiler >> monitorGCActivity [
	"This instantiates a monitor that will run a process that will log the gc activity once per
	second"

	gcActivityMonitor := IllGCActivityMonitor new
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
	(Delay forMilliseconds: aDuration asMilliSeconds) wait.
	self stopProfiling ] fork
]

{ #category : 'api' }
IllAbstractProfiler >> profileOn: aBlock [

	profiledCode := aBlock asString.
	self startProfiling.
	"The nil at the end is necessary because else the value of the block is referenced inside
	the ensure: method. We don't want to keep the reference because it avoids the object from
	being garbage collected"
	[
	aBlock value.
	nil ] ensure: [ self stopProfiling ]
]

{ #category : 'accessing' }
IllAbstractProfiler >> profiledCode [

	^ profiledCode
]

{ #category : 'accessing - statistics' }
IllAbstractProfiler >> queryAllocationStats [

	^ self subclassResponsibility
]

{ #category : 'profiling' }
IllAbstractProfiler >> registerAllocation: anObject [

	samplingRate = 1 ifTrue: [
		"Sampling 100% capture all"
		self internalRegisterAllocation: anObject.
		^ self ].

	samplingCounter := samplingCounter + 1.
	samplingCounter > samplingRate denominator ifTrue: [ samplingCounter := 1 ].

	samplingCounter <= samplingRate numerator
		ifTrue: [ self internalRegisterAllocation: anObject ]
		ifFalse: [ ^ self ]
]

{ #category : 'profiling' }
IllAbstractProfiler >> registerAllocationUsingNewSamplingRate: anObject [

	"NEDDED: Change the sampling rate in the initialize to self samplingRate: 2552.
	Why that number? It was the result of a linear regression model:
	
	prof startProfiling.
	before := Smalltalk vm parameterAt: 34.	
	Object new.
	after :=Smalltalk vm parameterAt: 34.
	prof stopProfiling.
	after - before ""2040"" " 

	| nextSamplingThreshold |
	"Fast path for sampling 100% capture all"
	samplingRate = 0 ifTrue: [
		self internalRegisterAllocation: anObject.
		^ self ].

	nextSamplingThreshold := (Smalltalk vm parameterAt: 34) - startTime // samplingRate.

	nextSamplingThreshold > samplingCounter ifTrue: [
		self internalRegisterAllocation: anObject ].

	samplingCounter := nextSamplingThreshold
]

{ #category : 'accessing - statistics' }
IllAbstractProfiler >> reportGCStatsOn: stream [

	| oldSpaceEnd youngSpaceEnd memoryEnd fullGCs fullGCTime incrGCs incrGCTime tenureCount upTime rootOverflows |
	upTime := endTime - startTime.
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
IllAbstractProfiler >> samplingRate: aFraction [
	"I expect my argument to be a fraction. For example 4 / 5. That will mean that I will
	register 4 out of 5 allocations."
	"The default sampling rate is 1%, which, by our evaluations, still gives precise results and does not sacrifice too much performance"

	samplingRate := aFraction
]

{ #category : 'profiling' }
IllAbstractProfiler >> startProfiling [

	gcActivityMonitor run.
	self initializeVMStats.
	self instrument
]

{ #category : 'accessing' }
IllAbstractProfiler >> startTime [

	^ startTime
]

{ #category : 'profiling' }
IllAbstractProfiler >> stopProfiling [

	self uninstrument.
	self updateVMStats.
	gcActivityMonitor terminate.
	self announceProfilerStopedProfiling
]

{ #category : 'accessing - statistics' }
IllAbstractProfiler >> totalFullGCs [

	^ vmStats at: 7
]

{ #category : 'accessing - statistics' }
IllAbstractProfiler >> totalScavenges [

	^ vmStats at: 9
]

{ #category : 'accessing' }
IllAbstractProfiler >> totalTime [

	^ endTime - startTime
]

{ #category : 'profiling' }
IllAbstractProfiler >> uninstrument [

	instrumentator uninstrument
]

{ #category : 'profiling' }
IllAbstractProfiler >> updateVMStats [

	"totalTime := Time primUTCMicrosecondsClock - startTime."
	endTime := Smalltalk vm parameterAt: 34.
	Smalltalk vm getParameters keysAndValuesDo: [ :idx :value |
		value isInteger ifTrue: [ vmStats at: idx put: value - ((vmStats at: idx) ifNil: [ 0 ]) ] ]
]
