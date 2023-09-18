"
I am a trait that contains the basic behavior to wrap and intercept the allocator methods of Pharo. I am used by the specific profilers
"
Trait {
	#name : 'IllimaniTAllocatorWrapper',
	#instVars : [
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
	#category : 'IllimaniAllocationProfiler-Profiler Instrumentator',
	#package : 'IllimaniAllocationProfiler',
	#tag : 'Profiler Instrumentator'
}

{ #category : 'accessing - statistics' }
IllimaniTAllocatorWrapper >> beginningOfProfilingTime [

	^ beginningOfProfilingTime
]

{ #category : 'accessing - statistics' }
IllimaniTAllocatorWrapper >> endOfProfilingTime [

	^ endOfProfilingTime
]

{ #category : 'api' }
IllimaniTAllocatorWrapper >> forceUninstall [
	"Waring, do not use unless you cannot start the profiler because you have the
	MpCannotInstall exceptionp"

	MpMethodProxy allInstances do: #uninstall
]

{ #category : 'accessing - statistics' }
IllimaniTAllocatorWrapper >> fullGCCount [

	^ fullGCCount
]

{ #category : 'accessing - statistics' }
IllimaniTAllocatorWrapper >> incrementalGCCount [

	^ incrementalGCCount
]

{ #category : 'initialization' }
IllimaniTAllocatorWrapper >> initializeMethodProxies: aHandler [

	proxyBasicNew := MpMethodProxy onMethod: Behavior >> #basicNew handler: aHandler.
	proxyBasicNewKeyword := MpMethodProxy onMethod: Behavior >> #basicNew: handler: aHandler.

	"Not wrappint the method Number>>#@ because is always by far the must allocator method and
	it pollutes the results."
	proxyArrobas := MpNullMethodProxy onMethod: Number >> #@ handler: aHandler.

	proxyArrayClass := MpMethodProxy onMethod: Array class >> #new: handler: aHandler
]

{ #category : 'profiling' }
IllimaniTAllocatorWrapper >> initializeProfilingBasicStats [

	beginningOfProfilingTime := Time microsecondClockValue.
	incrementalGCCount := Smalltalk vm incrementalGCCount.
	fullGCCount := Smalltalk vm fullGCCount.
	totalGCTime := Duration milliSeconds: Smalltalk vm totalGCTime
]

{ #category : 'profiling' }
IllimaniTAllocatorWrapper >> installMethodProxies [

	proxyBasicNew install.
	proxyBasicNewKeyword install.
	proxyArrobas install.
	proxyArrayClass install
]

{ #category : 'testing' }
IllimaniTAllocatorWrapper >> isProfilingFinished [

	^ endOfProfilingTime isNotNil
]

{ #category : 'testing' }
IllimaniTAllocatorWrapper >> isProfilingStarted [

	^ beginningOfProfilingTime isNotNil
]

{ #category : 'api' }
IllimaniTAllocatorWrapper >> profileFor: aDuration [
	"Done with a fork because we don't want to block the ui thread since it allocates objects. "

	self startProfiling.
	[
	(Delay forDuration: aDuration) wait.
	self stopProfiling ] fork
]

{ #category : 'api' }
IllimaniTAllocatorWrapper >> profileOn: aBlock [

	self startProfiling.
	"The nil at the end is necessary because else the value of the block is referenced inside
	the ensure: method. We don't want to keep the reference because it avoids the object from
	being garbage collected"
	[
	aBlock value.
	nil ] ensure: [ self stopProfiling ]
]

{ #category : 'accessing - statistics' }
IllimaniTAllocatorWrapper >> totalGCTime [

	^ totalGCTime
]

{ #category : 'accessing - statistics' }
IllimaniTAllocatorWrapper >> totalProfiledTime [

	^ endOfProfilingTime - beginningOfProfilingTime
]

{ #category : 'profiling' }
IllimaniTAllocatorWrapper >> uninstallMethodProxies [

	proxyBasicNew uninstall.
	proxyBasicNewKeyword uninstall.
	proxyArrobas uninstall.
	proxyArrayClass uninstall
]

{ #category : 'profiling' }
IllimaniTAllocatorWrapper >> updateStatsWhenFinishingProfiling [

	endOfProfilingTime := Time microsecondClockValue.
	incrementalGCCount := Smalltalk vm incrementalGCCount - incrementalGCCount.
	fullGCCount := Smalltalk vm fullGCCount - fullGCCount.
	totalGCTime := (Duration milliSeconds: Smalltalk vm totalGCTime) - totalGCTime
]
