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
		'beginningOfProfilingTime',
		'incrementalGCCount',
		'fullGCCount',
		'totalGCTime',
		'endOfProfilingTime'
	],
	#category : 'IllimaniProfiler-Instrumentation',
	#package : 'IllimaniProfiler',
	#tag : 'Instrumentation'
}

{ #category : 'accessing - statistics' }
IllAbstractProfiler >> beginningOfProfilingTime [

	^ beginningOfProfilingTime
]

{ #category : 'accessing - statistics' }
IllAbstractProfiler >> endOfProfilingTime [

	^ endOfProfilingTime
]

{ #category : 'api' }
IllAbstractProfiler >> forceUninstall [
	"Warning, do not use unless you cannot start the profiler because you have the
	MpCannotInstall exception"

	MpMethodProxy allInstances do: #uninstall
]

{ #category : 'accessing - statistics' }
IllAbstractProfiler >> fullGCCount [

	^ fullGCCount
]

{ #category : 'accessing' }
IllAbstractProfiler >> illimaniAnnouncer [

	^ IllAnnouncer new
]

{ #category : 'accessing - statistics' }
IllAbstractProfiler >> incrementalGCCount [

	^ incrementalGCCount
]

{ #category : 'initialization' }
IllAbstractProfiler >> initialize [

	super initialize.
	handler := IllMpHandler new
		profiler: self;
		yourself.
	self initializeMethodProxies: handler.
	samplingCounter := 0.
	samplingRate := 1
]

{ #category : 'initialization' }
IllAbstractProfiler >> initializeMethodProxies: aHandler [

	proxyBasicNew := MpMethodProxy onMethod: Behavior >> #basicNew handler: aHandler.
	proxyBasicNewKeyword := MpMethodProxy onMethod: Behavior >> #basicNew: handler: aHandler.

	"Not wrapping the method Number>>#@ because is always by far the must allocator method and
	it pollutes the results."
	proxyArrobas := MpNullMethodProxy onMethod: Number >> #@ handler: aHandler.

	proxyArrayClass := MpMethodProxy onMethod: Array class >> #new: handler: aHandler
]

{ #category : 'profiling' }
IllAbstractProfiler >> initializeProfilingBasicStats [

	beginningOfProfilingTime := Time primUTCMicrosecondsClock.
	incrementalGCCount := Smalltalk vm incrementalGCCount.
	fullGCCount := Smalltalk vm fullGCCount.
	totalGCTime := Duration milliSeconds: Smalltalk vm totalGCTime
]

{ #category : 'profiling' }
IllAbstractProfiler >> installMethodProxies [

	proxyBasicNew install.
	proxyBasicNewKeyword install.
	proxyArrobas install.
	proxyArrayClass install
]

{ #category : 'profiling' }
IllAbstractProfiler >> internalRegisterAllocation: anObject [

	^ self subclassResponsibility
]

{ #category : 'testing' }
IllAbstractProfiler >> isProfilingFinished [

	^ endOfProfilingTime isNotNil
]

{ #category : 'testing' }
IllAbstractProfiler >> isProfilingStarted [

	^ beginningOfProfilingTime isNotNil
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

{ #category : 'accessing' }
IllAbstractProfiler >> profilerHandler [

	^ handler
]

{ #category : 'profiling' }
IllAbstractProfiler >> registerAllocation: anObject [

	"Sampling"
	"samplingCounter := samplingCounter + 1.
	samplingCounter % samplingRate = 0 ifFalse: [ ^ anObject ]."
	
	self internalRegisterAllocation: anObject
]

{ #category : 'accessing' }
IllAbstractProfiler >> samplingRate [

	^ samplingRate
]

{ #category : 'api' }
IllAbstractProfiler >> samplingRate: anInteger [
	"The anInteger needs to be an integer number between 1 and 100.  "

	samplingRate := (100 / anInteger) asInteger
]

{ #category : 'profiling' }
IllAbstractProfiler >> startProfiling [

	self installMethodProxies.
	self initializeProfilingBasicStats
]

{ #category : 'accessing - statistics' }
IllAbstractProfiler >> stats [

	^ self subclassResponsibility
]

{ #category : 'profiling' }
IllAbstractProfiler >> stopProfiling [

	self uninstallMethodProxies.
	self updateStatsWhenFinishingProfiling
]

{ #category : 'accessing - statistics' }
IllAbstractProfiler >> totalGCTime [

	^ totalGCTime
]

{ #category : 'accessing - statistics' }
IllAbstractProfiler >> totalProfiledTime [

	^ endOfProfilingTime - beginningOfProfilingTime
]

{ #category : 'profiling' }
IllAbstractProfiler >> uninstallMethodProxies [

	proxyBasicNew uninstall.
	proxyBasicNewKeyword uninstall.
	proxyArrobas uninstall.
	proxyArrayClass uninstall
]

{ #category : 'profiling' }
IllAbstractProfiler >> updateStatsWhenFinishingProfiling [

	endOfProfilingTime := Time primUTCMicrosecondsClock.
	incrementalGCCount := Smalltalk vm incrementalGCCount - incrementalGCCount.
	fullGCCount := Smalltalk vm fullGCCount - fullGCCount.
	totalGCTime := (Duration milliSeconds: Smalltalk vm totalGCTime) - totalGCTime
]
